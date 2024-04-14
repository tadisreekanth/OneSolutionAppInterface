//
//  SerialDetailsView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 07/03/24.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionTextField

struct SerialDetailsView: View {
    @Binding var showSelf: String?
    @ObservedObject var viewModel: SerialDetailsViewModel
            
    init(_ showMe: Binding<String?>, viewModel: SerialDetailsViewModel) {
        self._showSelf = showMe
        self.viewModel = viewModel
    }

    var body: some View {
        OneSolutionBaseView {
            HeaderView(back: (true, {
                self.showSelf = ""
            }), home: (true, {
                self.showSelf = ""
            }), title: "SerialDetails")
            
            VStack {
                VStack (alignment: .leading) {
                    Text("Reference")
                    
                    OneSolutionTextField(viewModel: viewModel.tfReferenceViewModel)
                    
                    OneSolutionTextField(viewModel: viewModel.tfSerialViewModel)
                }
                
                VStack (alignment: .leading) {
                    HStack {
                        (viewModel.selectedAll ? AssetIcon.checkbox_yes.image : AssetIcon.checkbox_no.image)
                            .frame(width: 25, height: 25)
                        
                        Text("SELECT ALL")
                            .font(.system(size: 14))
                    }
                    
                    HStack {
                        (viewModel.selectedServices ? AssetIcon.checkbox_yes.image : AssetIcon.checkbox_no.image)
                            .frame(width: 25, height: 25)

                        Text("Services")
                    }
                    
                    HStack {
                        Text("Witem #")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        Text(viewModel.wItem)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                ScrollView {
                    VStack {
                        ForEach(serialKeys, id: \.self) { key in
                            Text(key)
                                .padding()
                        }
                    }
                }

                Spacer()
                
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image(systemName: "printer")
                            .padding(.trailing, 8)
                        Text("Print Barcode")
                    }
                })
                
            }
            .padding(.horizontal, 16)
        }
    }
}


extension SerialDetailsView {
    var serialKeys : [String] {
        ["witem",
         "serial",
         "siteName",
         //                      "siteGroupDes",
         "msoId",
         "customerName",
         //                      "makeDesc",
         "modelDesc",
         "status",
         "barcode",
         "receivedDate",
         "startDate",
         //                      "completelyReceived",
         "storageName",
         "delearName",
         "statusTime",
         "overallStatus",
         "outBoundBol",
         "salesOrderNumber",
         "barcodeUniqueSeq",
         "sequenceOfFiledsForQrCodeForParent"
        ]
    }
    
    var childKeys: [String] {
        ["witem",
         "serialNum",
         "msoid",
         "modelDesc",
         "make",
         "current_por",
         "date_received",
         "sales_order",
         "overall_status",
         "overall_work_order_status",
         "mfg_release_date",
         "sequenceOfFiledsForQrCodeForChild",
         "barcodeUniqueSeq"
        ]
    }
}

#Preview {
    SerialDetailsView(Binding.constant("SerialDetails"), 
                      viewModel: SerialDetailsViewModel())
}
