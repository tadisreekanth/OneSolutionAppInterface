//
//  InventoryFunction.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 28/03/24.
//

import SwiftUI
import OneSolutionUtility

struct InventoryFunctionView: View {
    let icon: AssetIcon
    let title: String
    let onTap: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                onTap?()
            } label: {
                VStack {
                    icon.image
                        .frame(width: 30, height: 30)
                    Text(title)
                        .font(Font.system(size: appFont12).bold())
                        .foregroundColor(.app_black)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    InventoryFunctionView(icon: .stop, title: "Pause") {
        
    }
}
