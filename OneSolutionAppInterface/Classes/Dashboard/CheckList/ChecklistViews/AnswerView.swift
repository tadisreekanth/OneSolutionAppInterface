//
//  AnswerView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 07/04/24.
//

import SwiftUI

struct AnswerView: View {
    @State private var text: String = ""

    var body: some View {
        TextField("Enter text", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(minHeight: 100)
    }
}

#Preview {
    AnswerView()
}
