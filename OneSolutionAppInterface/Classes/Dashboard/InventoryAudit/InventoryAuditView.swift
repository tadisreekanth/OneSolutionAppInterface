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
    
    @ObservedObject var viewModel: InventoryAuditViewModel
                
    init(viewModel: InventoryAuditViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        OneSolutionBaseView {
            VStack {
                HeaderView(back: (true, {
                    
                    viewModel.saveBeforExit(toRootView: false)
                    
                }), home: (true, {
                    
                    viewModel.saveBeforExit(toRootView: true)
                    
                }), title: "Inventory Audit")
                
                VStack(spacing: 10) {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Site Group")
                        OneSolutionTextField(
                            viewModel: viewModel.tfSiteGroupViewModel
                        )
                    }
                    
                    //Header
                    ZStack() {
                        VStack(alignment: .center) {
                            Text("SCANNED LIST")
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(isActive: $viewModel.showSettings) {
                                SettingsView(
                                    $viewModel.showSettings
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
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.arrScanSerials, id: \.uuid) { inventory in
                                VStack {
                                    Text("Serial: \(inventory.serial ?? "")")
                                    Text("Date  : \(inventory.date ?? "")")
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //Footer
                    HStack(alignment: .center) {
                        
                        let startIcon = viewModel.inventoryFunction.startIconAsset
                        
                        InventoryFunctionView(
                            icon: startIcon.0,
                            title: startIcon.1,
                            onTap: viewModel.startAction
                        )
                        
                        let pauseIcon = viewModel.inventoryFunction.pauseIconAsset

                        InventoryFunctionView(
                            icon: pauseIcon.0,
                            title: pauseIcon.1,
                            onTap: viewModel.pauseAction
                        )
                        
                        InventoryFunctionView(
                            icon: .stop,
                            title: "Stop",
                            onTap: viewModel.completeAction
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
            .alert(isPresented: $viewModel.showExitAlert) {
                Alert(title: Text(""),
                      message: Text("What would you like to do this service ?"),
                      primaryButton:
                        .default(Text("PAUSE"), action: {
                            //TODO: include actions
                            viewModel.showExitAlert = false
                        }),
                      secondaryButton:
                        .default(Text("COMPLETE"), action: {
                            //TODO: include actions
                            viewModel.showExitAlert = false
                        })
                )
            }
            .alert(isPresented: $viewModel.showSettingsAlert) {
                Alert(title: Text(""),
                      message: Text(viewModel.alertMessage),
                      dismissButton:
                        .destructive(Text("OK"), action: {
                            viewModel.showSettingsAlert = false
                        })
                )
            }
            .sheet(isPresented: $viewModel.showScanView) {
                ScannerView(
                    isUnlimitedScan: true,
                    scanTypes: viewModel.scanTypes
                ) { scanResponse, errorMessage in
                    if !errorMessage.isEmpty {
                        ToastPresenter.shared.presentToast(text: errorMessage)
                    } else {
                        viewModel.onScanResponseReceived(scanResponse)
                    }
                } onClose: {
                    viewModel.showScanView = false
                    viewModel.objectWillChange.send()
                    viewModel.savetoDefaults()
                }
            }
        }
    }
}

struct InventoryAuditView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryAuditView(
            viewModel: InventoryAuditViewModel(showSelf: Binding.constant("InventoryAudit"))
        )
    }
}
