//
//  ChecklistsView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 06/04/24.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionTextField

struct ChecklistsView: View {
    @Binding var showSelf: String?
    
    init(showSelf: Binding<String?>) {
        self._showSelf = showSelf
    }
    
    var body: some View {
        OneSolutionBaseView {
            HeaderView(back: (true, {
                self.showSelf = ""
            }), home: (true, {
                self.showSelf = ""
            }), title: "CheckList")
            ScrollView {
                VStack {
                    ChecklistHeaderView()
                    
                    ForEach(0..<5) { _ in
                        ChecklistView(
                            viewModel: ChecklistViewModel()
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    ChecklistsView(showSelf: Binding.constant(""))
}
