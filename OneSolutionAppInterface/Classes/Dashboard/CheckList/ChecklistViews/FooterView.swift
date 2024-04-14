//
//  FooterView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 08/04/24.
//

import SwiftUI
import OneSolutionUtility

struct FooterView: View {
    var action: ((Int) -> Void)?
    
    var body: some View {
        HStack {
            Button {
                action?(0)
            } label: {
                HStack {
                    AssetIcon.remarks.image
                    Text("Remarks")
                }
            }
            
            
            Button {
                action?(1)
            } label: {
                HStack {
                    AssetIcon.camera.image
                    Text("Upload Images") + Text("*")
                }
            }
        }
    }
}

#Preview {
    FooterView()
}
