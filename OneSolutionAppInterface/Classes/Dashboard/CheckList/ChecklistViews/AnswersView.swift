//
//  AnswersView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 07/04/24.
//

import SwiftUI

struct AnswersView: View {
    let list: [String]
    var body: some View {
        ScrollView {
            VStack {
                if #available(iOS 14.0, *) {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100))
                        // Allow the width of items to adapt based on content
                    ], spacing: 10) {
                        ForEach(list, id: \.self) { answer in
                            Text("\(answer)")
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity)  //Fixed height for each grid item
//                                .padding(.horizontal, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    // Fallback on earlier versions
                    ForEach(list, id: \.self) { element in
                        Text(element)
                    }
                }
            }
        }
    }
}

#Preview {
    AnswersView(list: ["To", "create", "a grid view", "with fixed", "height", "and", "adjustable", "width", "items", "in", "SwiftUI", "you can use", "LazyVGrid", "with a fixed height for rows", "and allow", "the width", "of", "each item", "to", "adapt based", "on", "the content", "Here's how you can achieve this"])
}
