//
//  PORLocationView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 08/03/24.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI
import OneSolutionTextField

@available(iOS 14.0, *)
struct PORLocationView: View {
    
    @Binding var showSelf: String?
    @ObservedObject var viewModel: PORLocationViewModel
    
    init(_ showMe: Binding<String?>, viewModel: PORLocationViewModel) {
        self._showSelf = showMe
        self.viewModel = viewModel
    }
    
    var body: some View {
        OneSolutionBaseView {
            HeaderView(back: (true, {
                self.showSelf = ""
            }), home: (true, {
                self.showSelf = ""
            }), title: "POR Location")
            
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Serial #")
                        
                        OneSolutionTextField(viewModel: viewModel.tfSerialViewModel)
                    }
                    
                    if viewModel.previousDetailsExists {
                        VStack (alignment: .center) {
                            HStack {
                                Spacer()
                                
                                self.previousDetails(title: "LOT", value: viewModel.previousLocations?.siteId ?? "")
//                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                                Spacer()
                                
                                self.previousDetails(title: "Area", value: viewModel.previousLocations?.storage ?? "")
//                                    .frame(minWidth: 0, maxWidth: .infinity)

                                Spacer()
                                
                                self.previousDetails(title: "Row", value: viewModel.previousLocations?.row ?? "")
//                                    .frame(minWidth: 0, maxWidth: .infinity)

                                Spacer()
                                
                                self.previousDetails(title: "Space", value: viewModel.previousLocations?.column ?? "")

                                Spacer()

                                
                                
//                                VStack {
//                                    Text("LOT")
//                                }
//                                Text("LOT\n\(viewModel.previousLocations?.siteId ?? "")")
//                                    .font(.system(size: textFieldFont))
//                                    .frame(minWidth: 0, maxWidth: .infinity)
//                                Text("Area\n\(viewModel.previousLocations?.storage ?? "")")
//                                    .font(.system(size: textFieldFont))
//                                    .frame(minWidth: 0, maxWidth: .infinity)
//                                Text("Row\n\(viewModel.previousLocations?.row ?? "")")
//                                    .font(.system(size: textFieldFont))
//                                    .frame(minWidth: 0, maxWidth: .infinity)
//                                Text("Space\n\(viewModel.previousLocations?.column ?? "")")
//                                    .font(.system(size: textFieldFont))
//                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("LOT")
                        
                        OneSolutionTextField(viewModel: viewModel.tfLOTViewModel)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Area")
                        
                        OneSolutionTextField(viewModel: viewModel.tfAreaViewModel)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Row")
                        
                        OneSolutionTextField(viewModel: viewModel.tfRowViewModel)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Space")
                        
                        OneSolutionTextField(viewModel: viewModel.tfSpaceViewModel)
                            .datePickerStyle(.wheel)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Storage Date")
                        
                        HStack {
                            VStack {
                                DatePicker("", selection: $viewModel.startDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .edgesIgnoringSafeArea(.all)
                            
                            VStack {
                                DatePicker("", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            HStack (spacing: 8) {
                Button {
                    DispatchQueue.main.async {
                        viewModel.updatePORLocation()
                    }
                } label: {
                    Text("Update")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.app_blue)
                        .foregroundColor(.app_black)
                }
                
                Button {
                    DispatchQueue.main.async {
                        self.showSelf = nil
                    }
                } label: {
                    Text("Cancel")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.app_blue)
                        .foregroundColor(.app_black)
                }
            }
        }
        .sheet(isPresented: $viewModel.showScanView, content: {
            ScannerView(
                scanTypes: [.cargoId]
            ) { scanResponse, errorMessage in
                let barcode =  scanResponse?[.barcodeUnique] as? String
                if let str = scanResponse?[.cargoId] as? String {
                    viewModel.scannedSerial = str
                    let previousState = viewModel.tfSerialViewModel.callAPIWhenTextChanged
                    viewModel.tfSerialViewModel.callAPIWhenTextChanged = false
                    viewModel.tfSerialViewModel.userInput = str
                    viewModel.getVinDetails(str, barcodeUnique: barcode ?? "")
                    viewModel.tfSerialViewModel.callAPIWhenTextChanged = previousState
                } else if !errorMessage.isEmpty {
                    ToastPresenter.shared.presentToast(text: errorMessage)
                }
            } onClose: {
                viewModel.showScanView = false
            }
        })
        .onAppear {
            viewModel.startDate = Date()
            viewModel.startTime = Date()
        }
    }
    
    private func previousDetails(title: String, value: String) -> some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.system(size: textFieldFont).bold())
            Text(value)
                .font(.system(size: textFieldFont))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
}

#Preview {
    if #available(iOS 14.0, *) {
        PORLocationView(Binding.constant("PORLocationView"), viewModel: PORLocationViewModel())
    } else {
        // Fallback on earlier versions
        EmptyView()
    }
}
