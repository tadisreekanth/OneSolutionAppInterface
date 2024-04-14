//
//  InstructionImagesView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 06/04/24.
//

import SwiftUI
import OneSolutionUtility

struct InstructionImagesView: View {
    var onTap: (()->Void)?
    var body: some View {
        HStack {
            Spacer()
            Button {
                
            } label: {
                Text("View Instructions Images")
            }
        }
        .basicHeight()
    }
}

#Preview {
    InstructionImagesView {
        
    }
}
