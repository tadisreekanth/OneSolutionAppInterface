//
//  BaseView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import OneSolutionUtility

struct OneSolutionBaseView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        // Fallback on earlier versions
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
        .updateNavigationTitleDisplayMode()
    }
}

extension OneSolutionBaseView {
    var image: some View {
        Image("bg_image")
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
