//
//  BaseView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import OneSolutionUtility

public struct OneSolutionBaseView<Content: View>: View {
    let content: Content
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    public var body: some View {
        ZStack {
            VStack {
                content
                Spacer()
            }
        }.background(
            bgImage
        )
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationTitleInlineMode()
    }
}

public extension OneSolutionBaseView {
    var image: some View {
        AssetImage.bgimage.image
            .resizable()
            .opacity(0.5)
    }
    var bgImage: some View {
        VStack {
            if #available(iOS 14.0, *) {
                image.ignoresSafeArea(.all, edges: .all)
            } else {
                // Fallback on earlier versions
                image
            }
        }
    }
}

struct OneSolutionBaseView_Previews: PreviewProvider {
    static var previews: some View {
        OneSolutionBaseView {
            HeaderView(logout: (true, {
                
            }), title: "ProcessWorkorder")
        }
    }
}
