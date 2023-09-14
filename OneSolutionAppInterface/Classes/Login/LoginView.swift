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
struct LoginView: View {
    @State var userName: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var user: UserBean
    
    @State private var showURLSettingsView = false

    var body: some View {
        NavigationView {
            OneSolutionBaseView {
                VStack {
                    Spacer()
                    loginView
                    Spacer()
                    footerView
                }
            }
        }
        .onAppear {
//            if isSimulator {
//                if Base == localBase {
//                    userName = "KLS"
//                    password = "KLS"
//                } else {
//                    userName = "KLSIT"
//                    password = "KLSINFYZ"
//                }
//            }
        }
    }
}

//MARK: - UI

extension LoginView {
    var loginView: some View {
        VStack {
            OneSolutionTextField(input: $userName, showClear: true, callAPIWhenTextChanged: false, placeholder: "Enter User ID")
            Spacer().frame(height: 15)
            OneSolutionTextField(input: $password, showClear: true, callAPIWhenTextChanged: false, placeholder: "Enter Password")
            Spacer().frame(height: 20)
            Text("SIGN IN")
                .foregroundColor(Color.app_white)
                .font(.system(size: buttonFont))
                .padding(EdgeInsets(top: 8, leading: 14, bottom: 7, trailing: 14))
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
                    .font(.system(size: appFont10))
                Spacer().frame(width: 5)
            }
            VStack {
                NavigationLink(isActive: $showURLSettingsView) {
                    URLSettingsView(showSelf: $showURLSettingsView)
                } label: {
                    Text("update service url".uppercased())
                        .foregroundColor(.app_black)
                        .bold()
                        .font(.system(size: appFont12))
                        .alignmentGuide(VerticalAlignment.center) { _ in 0 }
                }
            }
        }
    }
}

//MARK: - update

extension LoginView {
    private func appVersionText() -> String {
        var appPointedTo = "Loc"
        if kAppBundleIdentifier == kBundleIdentifier_UAT {
            appPointedTo = "Uat"
        } else if kAppBundleIdentifier == kBundleIdentifier_EPC_UAT {
            appPointedTo = "Epc_Uat"
        } else if kAppBundleIdentifier == kBundleIdentifier_Production {
            appPointedTo = "Pro"
        }
        return "V \(appPointedTo) - \(kAppVersion) (\(kAppBuild))"
    }
}

//MARK: - Action

extension LoginView {
    
    private func handleLoginAction() {
        Task {
            ProgressPresenter.shared.showProgress()
            let result = await LoginAPI.shared.loginWith(userName: userName,
                                                    password: password)
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
