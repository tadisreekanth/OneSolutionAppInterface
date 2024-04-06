//
//  SerialDetailsViewModel.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 15/03/24.
//

import Foundation
import OneSolutionTextField
import OneSolutionAPI

class SerialDetailsViewModel: ObservableObject {
    
    @Published var tfReferenceViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfSerialViewModel = OneSolutionTextFieldViewModel.defaultInstance
        
    @Published var showScanView: Bool = false
    
    @Published var selectedAll: Bool = false
    @Published var selectedServices: Bool = false
    
    @Published var wItem: String = ""
    
    init() {
        self.tfSerialActions()
        self.tfReference()
    }
}

extension SerialDetailsViewModel {
    
    func tfReference() {
        let key = "porTxt"
        let params: [String: Any] = [key: "",
                                     "user": kUserId,]        
        //        params.setValue(self.getPOR()?.shipmentDetailId ?? 0, forKey: "shipmentDetailsId")
        //        params.setValue(self.getPOR()?.cargoId ?? 0, forKey: "cargoId")
        //        params.setValue(SitegroupId, forKey: "SitegroupId")
        
        let request = OneSolutionRequest(url_String: "", requestParams: params, searchValueKey: key)
        
        self.tfReferenceViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "Please select reference",
            showRightView: true,
            rightIcon: .down_arrow,
            showClear: true,
            request: request,
            onRightImageTap: {
                
            }, onTextChange: {
                
            }, onClearTap: {
                
            }, onAPIResponse: { data in
                
            }, onSelected: { model in
                
            })
    }
}

//Serial TF
extension SerialDetailsViewModel {
    
    func tfSerialActions() {
        let key = "searchTxt"
        let paramsSerial: [String: Any] = [:]
        //        paramsSerial.setValue(kUserID, forKey: "userId")
        //        paramsSerial.setValue("", forKey: key)
        //        paramsSerial.setValue(scanKey_cargoId, forKey: "referenceName")
        //        paramsSerial.setValue(50, forKey: "maxValues")
        //        paramsSerial.setValue("", forKey: scanKey_barcodeUnique)
        
        let request = OneSolutionRequest(url_String: "", requestParams: paramsSerial, searchValueKey: key)
        
        
        self.tfSerialViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "SERIAL #",
            showRightView: true,
            rightIcon: .camera,
            showClear: true,
            request: request,
            objectType: Serial.self,
            onRightImageTap: { [weak self] in
                DispatchQueue.main.async {
                    self?.showScanView = true
                }
            }, onTextChange: {
                
            }, onClearTap: {
                
            }, onAPIResponse: { data in
                
            }, onSelected: { model in
                
            })
    }
}
