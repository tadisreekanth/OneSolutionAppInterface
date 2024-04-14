//
//  QuestionsView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 06/04/24.
//

import SwiftUI
import OneSolutionUtility

struct QuestionsView: View {
    let index: Int
    let text: String
    let hideToggle: Bool
    let isMandatoryAnswerable: Bool
    var body: some View {
        ZStack {
            if isMandatoryAnswerable {
                Text("\(index). \(text)")
                    .font(.system(size: appFont12))
                    .foregroundColor(Color.app_black)
                +
                Text(" *")
                    .font(.system(size: appFont13))
                    .foregroundColor(Color.red)
            } else {
                Text("\(index). \(text)")
            }
            
            if !hideToggle {
                Divider()
                    .frame(width: 1)
                    .background(Color.red)
            }
        }
    }
}

#Preview {
    QuestionsView(index: 1, text: "Question", hideToggle: true, isMandatoryAnswerable: true)
}
