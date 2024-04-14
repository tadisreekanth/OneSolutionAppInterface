//
//  CheckListImagesView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 08/04/24.
//

import SwiftUI

struct CheckListImagesView: View {
    var list: [String]
    var body: some View {
        ScrollView {
            HStack {
                ForEach(list, id: \.self) { url in
//                    image
                    Text(url)
                }
            }
        }
    }
}

#Preview {
    CheckListImagesView(list: [])
}
