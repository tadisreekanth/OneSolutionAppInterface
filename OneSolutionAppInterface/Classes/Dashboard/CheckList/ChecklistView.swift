//
//  ChecklistView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 11/04/24.
//

import SwiftUI

struct ChecklistView: View {
    var viewModel: ChecklistViewModel

    var body: some View {
        VStack {
            InstructionsView(
                text: "Instructions"
            )
            
            InstructionImagesView(
                onTap: viewModel.onInstructionImagesTap
            )
            
            QuestionsView(
                index: 1,
                text: "Question",
                hideToggle: true, 
                isMandatoryAnswerable: true
            )
            
            AnswerView()
            
            AnswersView(
                list: ["To", "create", "a grid view", "with fixed", "height", "and", "adjustable", "width", "items", "in", "SwiftUI", "you can use", "LazyVGrid", "with a fixed height for rows", "and allow", "the width", "of", "each item", "to", "adapt based", "on", "the content", "Here's how you can achieve this"]
            )
            
            ChecklistServiceOptionsView()
            
            MailView()
            
            DateView()
            
            CaptureImageView (
                action: viewModel.onAddCaptureImagesTap
            )
            
            CheckListImagesView(
                list: []
            )
            
            CaptureImageView(
                isSignature: true, 
                action: viewModel.onAddSignatureTap
            )
            
            CaptureImageView(
                isRecordDamage: true,
                action: viewModel.onAddRecordDamageTap
            )
            
            FooterView { index in
                if index == 1 {
                    // upload images
                } else {
                    // remarks
                }
            }
            
            RemarksView()
        }
    }
}

#Preview {
    ChecklistView(
        viewModel: ChecklistViewModel()
    )
}
