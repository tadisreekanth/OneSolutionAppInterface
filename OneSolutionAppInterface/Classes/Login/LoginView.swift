//
//  LoginView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI
import OneSolutionTextField

@available (iOS 13.0.0, *)
public struct LoginView: View {
    //    @State var userName: String = ""
    //    @State var password: String = ""
    @EnvironmentObject public var user: UserBean
    @State private var showingURLSettingsView = false
    
    var userNameTextFieldViewModel: OneSolutionTextFieldViewModel
    var passwordTextFieldViewModel: OneSolutionTextFieldViewModel
    
    public init() {
        let credentials = APIClient.shared?.appConstants?.defaultCredentials
        userNameTextFieldViewModel = OneSolutionTextFieldViewModel(
            input: credentials?.userName ?? "",
            placeholder: "Enter User ID",
            showClear: true,
            callAPIWhenTextChanged: false
        )
        passwordTextFieldViewModel = OneSolutionTextFieldViewModel(
            input: credentials?.password ?? "",
            placeholder: "Enter Password",
            showClear: true,
            callAPIWhenTextChanged: false
        )
    }
    
    public var body: some View {
        OneSolutionBaseView {
            VStack {
                Spacer()
                loginView
                Spacer()
                footerView
            }
        }
    }
}

//MARK: - UI

public extension LoginView {
    var loginView: some View {
        VStack(spacing: 12) {
            OneSolutionTextField(
                viewModel: userNameTextFieldViewModel
            )
            
            OneSolutionTextField(
                viewModel: passwordTextFieldViewModel
            )
            .padding(.bottom, 3)
            
            Text("SIGN IN")
                .foregroundColor(Color.app_white)
                .font(.system(size: buttonFont))
                .padding(.horizontal, 14) // EdgeInsets(top: 8, leading: 14, bottom: 7, trailing: 14))
                .padding(.vertical, 7)
                .background(Color.app_blue)
                .cornerRadius(buttonCornerRadius)
                .onTapGesture {
                    self.handleLoginAction()
                }
        }
        .padding(15)
        .padding(.top, 5)
        .background(Color.app_bg)
        .cornerRadius(10)
        .clipped()
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
    
    var footerView: some View {
        ZStack {
            HStack {
                Spacer()
                Text(self.appVersionText())
                    .foregroundColor(.app_white)
                    .font(.system(size: appFont11))
                    .padding(.trailing, 5)
            }
            VStack {
                NavigationLink(isActive: $showingURLSettingsView) {
                    URLSettingsView(showSelf: $showingURLSettingsView)
                } label: {
                    Text("update service url".uppercased())
                        .foregroundColor(.app_black)
                        .bold()
                        .font(.system(size: appFont12))
                }
            }
        }
    }
}

//MARK: - Helper
public extension LoginView {
    private var appConstants: AppConstants? {
        APIClient.shared?.appConstants
    }
    private func appVersionText() -> String {
        let appEnvironment = appConstants?.appEnvironmentText ?? ""
        let appVersion = appConstants?.appVersion ?? ""
        let appBuild = appConstants?.buildVersion ?? ""
        
        return "V \(appEnvironment) - \(appVersion) (\(appBuild))"
    }
}

//MARK: - Action
public extension LoginView {
    private func handleLoginAction() {
        Task {
            ProgressPresenter.shared.showProgress()
            let result = await LoginAPI.instance.loginWith(userName: userNameTextFieldViewModel.userInput,
                                                           password: passwordTextFieldViewModel.userInput)
            ProgressPresenter.shared.hideProgress()
            switch result {
            case .success(let login):
                //store and pass data
                user.update(with: login)
            case .failure(let error):
                switch error {
                case .errorMessage(let message):
                    ToastPresenter.shared.presentToast(text: message)
                default:
                    break
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
