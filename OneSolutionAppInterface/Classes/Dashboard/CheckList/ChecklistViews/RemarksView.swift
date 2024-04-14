//
//  RemarksView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 08/04/24.
//

import SwiftUI

struct RemarksView: View {
    @State private var text: String = ""
    
    var body: some View {
        TextField("Enter text", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(minHeight: 100)
    }
}

#Preview {
    RemarksView()
}
