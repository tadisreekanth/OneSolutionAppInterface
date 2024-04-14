//
//  DateView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 07/04/24.
//

import SwiftUI

struct DateView: View {
    @State var date = Date()
    
    var body: some View {
        HStack {
            VStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
            }
            .background(Color.white)
            .cornerRadius(10)
            .edgesIgnoringSafeArea(.all)
            Spacer()
        }
    }
}

#Preview {
    DateView()
}
