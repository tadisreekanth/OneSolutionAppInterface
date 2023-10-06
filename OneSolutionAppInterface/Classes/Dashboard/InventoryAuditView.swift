//
//  InventoryAuditView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 05/10/23.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI
import OneSolutionTextField

struct InventoryAuditView: View {
    @Binding var showSelf: String?
    @State private var showSettings: Bool = false
    
    var tfSiteGroupViewModel: OneSolutionTextFieldViewModel
    
    var arrScanSerials = [Inventaroy] ()
    
    init(_ showSelf: Binding<String?>) {
        self._showSelf = showSelf
        self.tfSiteGroupViewModel = OneSolutionTextFieldViewModel(input: "",
                                                                  placeholder: "Enter Site Group or choose",
                                                                  showRightView: true,
                                                                  rightIcon: .down_arrow,
                                                                  showClear: true)
    }
    
    var body: some View {
        OneSolutionBaseView {
            VStack {
                HeaderView(back: (true, {
                    self.showSelf = ""
                }), home: (true, {
                    self.showSelf = ""
                }), title: "Inventory Audit")
                
                VStack(spacing: 10) {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Site Group")
                        OneSolutionTextField(
                            viewModel: tfSiteGroupViewModel
                        )
                    }
                    
                    //Header
                    ZStack() {
                        VStack(alignment: .center) {
                            Text("SCANNED LIST")
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(isActive: $showSettings) {
                                SettingsView(
                                    $showSettings
                                )
                            } label: {
                                VStack {
                                    AssetIcon.settings.image
                                        .frame(width: 25, height: 25)
                                    Text("Settings")
                                        .font(Font.system(size: 10))
                                }
                            }
                        }
                        .padding(5)
                    }
                    .background(Color.app_white)
                    //List
                    
                    Spacer()
                    
                    //Footer
                    HStack(alignment: .center) {
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                VStack {
                                    AssetIcon.start.image
                                        .frame(width: 30, height: 30)
                                    Text("Start")
                                        .font(Font.system(size: 10))
                                }
                            }
                            Spacer()
                        }
                        
                        
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                
                                VStack {
                                    AssetIcon.pause.image
                                        .frame(width: 30, height: 30)
                                    Text("Pause")
                                        .font(Font.system(size: 10))
                                }
                            }
                            Spacer()
                        }
                        
                        
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                VStack {
                                    AssetIcon.stop.image
                                        .frame(width: 30, height: 30)
                                    Text("Stop")
                                        .font(Font.system(size: 10))
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

struct InventoryAuditView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryAuditView(
            Binding.constant("InventoryAudit")
        )
    }
}
