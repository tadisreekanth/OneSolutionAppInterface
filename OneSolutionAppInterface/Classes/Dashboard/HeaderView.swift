//
//  HeaderView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct HeaderView: View {
    var back: headerTuple?
    var home: headerTuple?
    var logout: headerTuple?
    var complete: headerTuple?
    var signature: headerTuple?
    var title: String
        
    var body: some View {
        ZStack {
            HStack {
                if back?.0 ?? false {
                    HeaderButton(handler: back?.handler, imageName: icon_back)
                    Spacer()
                }
                if home?.0 ?? false {
                    HeaderButton(handler: home?.handler, imageName: (complete?.0 ?? false) ? icon_save : icon_home, title: (complete?.0 ?? false) ? "Save" : "")
                } else if logout?.0 ?? false {
                    Spacer()
                    HeaderButton(handler: logout?.handler, imageName: icon_logout)
                } else if complete?.0 ?? false {
                    HeaderButton(handler: complete?.handler, imageName: icon_save, title: "Complete")
                }
                if signature?.0 ?? false {
                    HeaderButton(handler: signature?.handler, imageName: icon_sign, title: "Signature")
                }
            }
            Text(title)
                .frame(alignment: .center)
                .foregroundColor(.black)
                .font(.system(size: titleFont))
            Spacer()
        }
        .frame(height: 44, alignment: .leading)
        .padding(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 10))
        .background(Color.app_separator2)
    }
    
    struct HeaderButton: View {
        var handler: noParamsHandler?
        var imageName: String
        var title: String?
        var body: some View {
            Button {
                handler?()
            } label: {
                if let title = title, !title.isEmpty {
                    VStack {
                        Image(imageName)
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text(title)
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                            .padding(.top, -10)
                    }
                    .basicHeight()
                } else {
                    Image(imageName)
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}

@available(iOS 13.0.0, *)
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        OneSolutionBaseView {
            HeaderView(logout: (true, {
                
            }), title: "ProcessWorkorder")
        }
    }
}
