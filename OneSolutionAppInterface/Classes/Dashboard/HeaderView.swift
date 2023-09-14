//
//  HeaderView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import OneSolutionUtility

@available(iOS 13.0.0, *)
struct HeaderView: View {
    var back: HeaderTuple?
    var home: HeaderTuple?
    var logout: HeaderTuple?
    var complete: HeaderTuple?
    var signature: HeaderTuple?
    var title: String
        
    var body: some View {
        ZStack {
            HStack {
                if back?.0 ?? false {
                    HeaderButton(
                        handler: back?.handler,
                        imageName: iconBack
                    )
                    Spacer()
                }
                if home?.0 ?? false {
                    HeaderButton(
                        handler: home?.handler,
                        imageName: (complete?.0 ?? false) ? iconSave : iconHome,
                        title: (complete?.0 ?? false) ? "Save" : ""
                    )
                } else if logout?.0 ?? false {
                    Spacer()
                    HeaderButton(
                        handler: logout?.handler,
                        imageName: iconLogout
                    )
                } else if complete?.0 ?? false {
                    HeaderButton(
                        handler: complete?.handler,
                        imageName: iconSave,
                        title: "Complete"
                    )
                }
                if signature?.0 ?? false {
                    HeaderButton(
                        handler: signature?.handler,
                        imageName: iconSignature,
                        title: "Signature")
                }
            }
            Text(title)
                .frame(alignment: .center)
                .foregroundColor(.black)
                .font(.system(size: titleFont))
            Spacer()
        }
        .frame(height: 44, alignment: .leading)
        .padding(.horizontal, 10)
        .background(Color.app_separator2)
    }
}

extension HeaderView {
    private var iconBack: String { AssetIcon.back_28.rawValue }
    
    private var iconSignature: String { AssetIcon.sign.rawValue }
    
    private var iconLogout: String { AssetIcon.logout.rawValue }
    
    private var iconHome: String { AssetIcon.home.rawValue }
    
    private var iconSave: String { AssetIcon.save.rawValue }
}

struct HeaderButton: View {
    var handler: EmptyParamsHandler?
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

@available(iOS 13.0.0, *)
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        OneSolutionBaseView {
            HeaderView(logout: (true, {
                
            }), title: "ProcessWorkorder")
        }
    }
}
