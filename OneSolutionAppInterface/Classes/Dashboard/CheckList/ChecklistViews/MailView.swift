//
//  MailView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 07/04/24.
//

import SwiftUI
import OneSolutionTextField

struct MailView: View {
    var body: some View {
        OneSolutionTextField(
            viewModel: OneSolutionTextFieldViewModel(input: "")
        )
    }
}

#Preview {
    MailView()
}
