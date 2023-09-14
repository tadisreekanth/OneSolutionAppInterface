//
//  URLSettingsView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct URLSettingsView: View {
    @State var url: String = Base
    @Binding var showSelf: Bool
    
    var body: some View {
        OneSolutionBaseView {
            VStack {
                Spacer()
                VStack {
                    VStack (alignment: .leading) {
                        Text("Service URL")
                            .padding(.bottom, -1)
                            .font(.system(size: textFieldHeadingFont))
                        OneSolutionTextField(input: $url, callAPIWhenTextChanged: false, placeholder: "http://115.243.3.254:18989")
                    }
                    Spacer().frame(height: 20)
                    HStack {
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
                        Spacer()
                            .frame(width: buttonsSpacing)
                        Text("RESET")
                            .foregroundColor(Color.app_white)
                            .font(.system(size: buttonFont))
                            .padding(EdgeInsets(top: 8, leading: 14, bottom: 7, trailing: 14))
                            .background(Color.app_blue)
                            .cornerRadius(buttonCornerRadius)
                            .onTapGesture {
                                self.url = ""
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
        if url.isEmpty {
            
        } else {
            kUserDefaults.setValue(url, forKey: keySelectedBaseURL)
            kUserDefaults.synchronize()
            
            ServiceAPI.shared = ServiceAPI ()
            
            self.showSelf = false
        }
    }
}

struct URLSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            URLSettingsView(showSelf: Binding.constant(false))
        }
    }
}
