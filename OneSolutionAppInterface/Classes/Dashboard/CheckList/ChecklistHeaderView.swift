//
//  CheckListHeaderView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 06/04/24.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionTextField

struct ChecklistHeaderView: View {
    var body: some View {
        VStack {
            //Service Num
            HStack {
                Text("Service Num Value")
                
                Spacer()
                
                //Answer Count percentage
                Text("5/10 (50%)")
                
                Button {
                    
                } label: {
                    VStack {
                        Spacer()
                        AssetIcon.save_blue.image
                            .frame(width: 25, height: 25)
                            .padding(.bottom, 0)
                        Text("Save")
                            .font(.system(size: appFont10))
                        Spacer()
                    }
                    .frame(width: 40)
                }
            }
            .frame(height: 40)
            
            //Location
            HStack {
                Text("Location")
                Spacer()
                Button {
                    
                } label: {
                    VStack {
                        Spacer()
                        AssetIcon.location.image
                            .frame(width: 25, height: 25)
                            .padding(.bottom, 0)
                        Text("Save")
                            .font(.system(size: appFont10))
                        Spacer()
                    }
                    .frame(width: 40)
                }
            }
            .frame(height: 40)
            
            
            //function
            HStack {
                InventoryFunctionView(
                    icon: .start,
                    title: "Start"
                ) {
                    
                }
                
                InventoryFunctionView(
                    icon: .stop,
                    title: "Stop"
                ) {
                    
                }
                
                Spacer()
                
                //Auto Save timer
                Text("05m:10s")
                
                Spacer()
                
                InventoryFunctionView(
                    icon: .link,
                    title: ""
                ) {
                    
                }
                
                InventoryFunctionView(
                    icon: .parts,
                    title: "Parts"
                ) {
                    
                }
            }
            .frame(height: 40)
            
            HStack {
                OneSolutionTextField(viewModel: OneSolutionTextFieldViewModel(input: ""))
                
                AssetIcon.tick_green.image
                    .frame(width: 40, height: 40)
            }
        }
    }
}

#Preview {
    ChecklistHeaderView()
}
