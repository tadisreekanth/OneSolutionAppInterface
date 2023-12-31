//
//  URLSettingsView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI
import OneSolutionTextField

@available(iOS 13.0.0, *)
struct URLSettingsView: View {
    private var url: String
    @Binding var showSelf: Bool
    
    var urlTextFieldViewModel: OneSolutionTextFieldViewModel
    
    init(showSelf: Binding<Bool>) {
        self.url = APIClient.shared?.route?.host ?? ""
        self._showSelf = showSelf
        self.urlTextFieldViewModel = OneSolutionTextFieldViewModel(
            input: self.url,
            placeholder: "http://115.243.3.254:18989",
            callAPIWhenTextChanged: false
        )
    }
    
    var body: some View {
        OneSolutionBaseView {
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    VStack (alignment: .leading) {
                        Text("Service URL")
                            .padding(.bottom, -1)
                            .font(.system(size: textFieldHeadingFont))
                        OneSolutionTextField(
                            viewModel: urlTextFieldViewModel
                        )
                    }
                    
                    HStack(spacing: buttonsSpacing) {
                        Spacer()
                        Text("SAVE")
                            .foregroundColor(Color.app_white)
                            .font(.system(size: buttonFont))
                            .padding(EdgeInsets(top: 8, leading: 14, bottom: 7, trailing: 14))
                            .background(Color.app_blue)
                            .cornerRadius(buttonCornerRadius)
                            .onTapGesture {
                                self.saveURL()
                            }
                        
                        Text("RESET")
                            .foregroundColor(Color.app_white)
                            .font(.system(size: buttonFont))
                            .padding(EdgeInsets(top: 8, leading: 14, bottom: 7, trailing: 14))
                            .background(Color.app_blue)
                            .cornerRadius(buttonCornerRadius)
                            .onTapGesture {
                                self.urlTextFieldViewModel.update(input: "")
                            }
                        Spacer()
                    }
                }
                .padding(15)
                .background(Color.app_bg)
                .cornerRadius(10)
                .clipped()
                .padding(.leading, 30)
                .padding(.trailing, 30)
                Spacer()
            }
        }
    }
}

extension URLSettingsView {
    func saveURL () {
        let kUserDefaults = UserDefaults.standard
        let userInput = self.urlTextFieldViewModel.userInput
        if !userInput.isEmpty {
            kUserDefaults.setValue(userInput, forKey: keySavedBaseURL)
            kUserDefaults.synchronize()
            
            APIClient.shared?.route?.hostUpdated()
            
            self.showSelf = false
        }
    }
}

struct URLSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        URLSettingsView(
            showSelf: Binding.constant(true)
        )
    }
}
