//
//  CaptureImageView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 07/04/24.
//

import SwiftUI
import OneSolutionUtility

struct CaptureImageView: View {
    var isSignature: Bool = false
    var isRecordDamage: Bool = false
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                HStack {
                    if isRecordDamage {
                        AssetIcon.estimated.image
                            .frame(width: 25, height: 25)
                    }
                    Text(isRecordDamage ? "Record Damage" : isSignature ? "Add Signature" : "Capture Images")
                }
                .frame(height: 40)
                .background(Color.gray)
                HStack {
                    Spacer()
                    AssetIcon.right_arrow.image
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

#Preview {
    CaptureImageView()
}
