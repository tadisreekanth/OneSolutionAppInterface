//
//  PORLocationViewModel.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 11/03/24.
//

import Foundation
import OneSolutionTextField
import OneSolutionAPI
import OneSolutionUtility

class PORLocationViewModel: ObservableObject {
    @Published var tfSerialViewModel = OneSolutionTextFieldViewModel.defaultInstance
    
    @Published var tfLOTViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfAreaViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfRowViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfSpaceViewModel = OneSolutionTextFieldViewModel.defaultInstance
    
    @Published var showScanView: Bool = false
    var scannedSerial: String?
    
    @Published var startDate = Date()
    @Published var startTime = Date()
    
    var porLocations: [PORLocationGeneral] = []
    @Published var previousLocations: PORLocationPreviousDetails?
    
    init() {
        self.initializeSerial()
        self.initializeLot()
        self.initializeRow()
        self.initializeArea()
        self.initializeSpace()
    }
}

//MARK: - Helper
extension PORLocationViewModel {
    private var canEditSerial: Bool {
        enableSearchForSerial
    }
    
    private var endPoints: GeneralPORLocationPath? {
        APIClient.shared?.path?.generalPORLocation
    }
    
    private var porLocation: PORLocationGeneral? {
        porLocations.first
    }
    
    var previousDetailsExists: Bool {
        guard let previousLocations = self.previousLocations else { return false }
        return !(previousLocations.siteId?.isEmpty ?? true) &&
        !(previousLocations.storage?.isEmpty ?? true) &&
        !(previousLocations.row?.isEmpty ?? true) &&
        !(previousLocations.column?.isEmpty ?? true)
    }
}

//MARK: - Allocations
extension PORLocationViewModel {
    
    private func initializeSerial() {
        let key = "searchTxt"
        let paramsSerial: [String: Any] = [key: "",
                                           "userId": kUserId,
                                           "referenceName": ScanKey.cargoId.rawValue,
                                           "maxValues": 50,
                                           ScanKey.barcodeUnique.rawValue: ""]
        
        let request = OneSolutionRequest(url_String: endPoints?.serial ?? "", requestParams: paramsSerial, searchValueKey: key)
        
        
        self.tfSerialViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "SERIAL #",
            isUpperCasedText: true,
            showRightView: true,
            rightIcon: .camera,
            showClear: true,
            canEdit: canEditSerial,
            callAPIWhenTextChanged: true,
            request: request,
            objectType: PORLocationSerial.self,
            onRightImageTap: { [weak self] in
                DispatchQueue.main.async {
                    self?.showScanView = true
                }
            }, onTextChange: {
                
            }, onClearTap: { [weak self] in
                
                self?.scannedSerial = nil
                self?.porLocations = []
                self?.previousLocations = nil
                self?.removeLot()
                
            }, onAPIResponse: { data in
                
            }, onSelected: { [weak self] model in
                
                self?.getVinDetails(model.displayName, barcodeUnique: "")
                self?.tfSerialViewModel.cancelTask()
                self?.tfSerialViewModel.update(models: nil)
            })
    }
}

extension PORLocationViewModel {
    
    private func initializeLot() {
        let key = "porTxt"
        let params: [String: Any] = [key: "",
                                     "user": kUserId,
                                     "shipmentDetailsId": 0,
                                     "cargoId": 0,
                                     "SitegroupId": ""]
        
        let request = OneSolutionRequest(url_String: endPoints?.lot ?? "", requestParams: params, searchValueKey: key)
        
        self.tfLOTViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "Please select LOT",
            showRightView: true,
            rightIcon: .down_arrow,
            showClear: true,
            callAPIWhenTextChanged: true,
            callAPIWhenRightIconTap: true,
            request: request,
            objectType: PORLocationLOT.self,
            onRightImageTap: { [weak self] in
                
                self?.updateLotValues()
                
            }, onTextChange: {
                
            }, onClearTap: { [weak self] in
                //remove selected values
                self?.removeArea()
                
            }, onAPIResponse: { data in
                
            }, onSelected: { [weak self] model in
                ///update area with Lot values
                self?.updateAreaValues()
            })
    }
    
    private func updateLotValues() {
        guard let _ = self.porLocation, let _ = self.previousLocations else {
            ToastPresenter.shared.presentToast(text: "Please scan Serial #")
            self.tfLOTViewModel.callAPIWhenTextChanged = false
            return
        }
        
        self.tfLOTViewModel.request?.update(value: self.porLocation?.shipmentDetailId ?? 0, for: "shipmentDetailsId")
        self.tfLOTViewModel.request?.update(value: self.porLocation?.cargoId ?? 0, for: "cargoId")
        self.tfLOTViewModel.request?.update(value: self.previousLocations?.sitegroupId.stringValue ?? "", for: "SitegroupId")
        
        self.tfLOTViewModel.callAPIWhenTextChanged = true
    }
}

extension PORLocationViewModel {
    
    private func initializeArea() {
        let paramsArea: [String: Any] = ["companyId": "",
                                         "userId": kUserId]
        
        let request = OneSolutionRequest(url_String: endPoints?.area ?? "", requestParams: paramsArea, searchValueKey: "")
        
        self.tfAreaViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "Please select Area",
            showRightView: true,
            rightIcon: .down_arrow,
            showClear: true,
            callAPIWhenTextChanged: true,
            callAPIWhenRightIconTap: true,
            request: request,
            objectType: PORLocationArea.self,
            onRightImageTap: { [weak self] in
                
                self?.updateAreaValues()
                
            }, onTextChange: {
                
            }, onClearTap: { [weak self] in
                
                self?.removeRow()
                
            }, onAPIResponse: { data in
                
            }, onSelected: { [weak self] model in
                
                ///update Row with Area values
                self?.updateRowValues()
            })
    }
    
    private func updateAreaValues() {
        guard self.isLotValid else {
            self.tfAreaViewModel.callAPIWhenTextChanged = false
            return
        }
        
        let companyId = self.tfLOTViewModel.request?.selectedObject?.params?["CompanyId"]?.stringValue ?? ""
        self.tfAreaViewModel.request?.update(value:companyId, for: "companyId")
        
        self.tfAreaViewModel.callAPIWhenTextChanged = true
    }
}

extension PORLocationViewModel {
    
    private func initializeRow() {
        let paramsRow: [String: Any] = ["id": 0,
                                        "userId": kUserId]
        
        let request = OneSolutionRequest(url_String: endPoints?.row ?? "", requestParams: paramsRow, searchValueKey: "")
        
        self.tfRowViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "Please select Row",
            showRightView: true,
            rightIcon: .down_arrow,
            showClear: true,
            callAPIWhenTextChanged: true,
            callAPIWhenRightIconTap: true,
            request: request,
            objectType: PORLocationRow.self,
            onRightImageTap: { [weak self] in
                
                self?.updateRowValues()
                
            }, onTextChange: {
                
            }, onClearTap: { [weak self] in
                
                self?.removeSpace()
                
            }, onAPIResponse: { data in
                
            }, onSelected: { [weak self] model in
                
                self?.updateSpaceValues()
            })
    }
    
    private func updateRowValues() {
        guard self.isLotValid, self.isAreaValid else {
            self.tfRowViewModel.callAPIWhenTextChanged = false
            return
        }
        
        let id = self.tfAreaViewModel.request?.selectedObject?.params?["id"]?.stringValue ?? ""
        self.tfRowViewModel.request?.update(value: id, for: "id")
        
        self.tfRowViewModel.callAPIWhenTextChanged = true
    }
}

extension PORLocationViewModel {
    
    private func initializeSpace() {
        let paramsSpace: [String: Any] = ["id": 0,
                                          "userId": kUserId]
        
        let request = OneSolutionRequest(url_String: endPoints?.column ?? "", requestParams: paramsSpace, searchValueKey: "")
        
        self.tfSpaceViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "Please select Space",
            showRightView: true,
            rightIcon: .down_arrow,
            showClear: true,
            callAPIWhenTextChanged: true,
            callAPIWhenRightIconTap: true,
            request: request,
            objectType: PORLocationSpace.self,
            onRightImageTap: { [weak self] in
                
                self?.updateSpaceValues()
                
            }, onTextChange: {
                
            }, onClearTap: {
                
            }, onAPIResponse: { data in
                
            }, onSelected: { model in
                
            })
    }
    
    private func updateSpaceValues() {
        guard self.isLotValid, self.isAreaValid, self.isRowValid else {
            self.tfSpaceViewModel.callAPIWhenTextChanged = false
            return
        }
        
        let id = self.tfRowViewModel.request?.selectedObject?.params?["id"]?.stringValue ?? ""
        self.tfSpaceViewModel.request?.update(value: id, for: "id")
        
        self.tfSpaceViewModel.callAPIWhenTextChanged = true
    }
}

//MARK: - Validations
extension PORLocationViewModel {
    private var allFieldsValidated: Bool {
        return isLotValid &&
        isAreaValid &&
        isRowValid &&
        isSpaceValid &&
        isStartDateValid &&
        isEndDateValid
    }
    
    private var isLotValid: Bool {
        guard !self.porLocations.isEmpty, let _ = self.previousLocations else {
            ToastPresenter.shared.presentToast(text: "Please scan Serial #")
            return false
        }
        guard !tfLOTViewModel.userInput.isEmpty, let _ = tfLOTViewModel.request?.selectedObject else {
            ToastPresenter.shared.presentToast(text: "Please select LOT")
            return false
        }
        return true
    }
    
    private var isAreaValid: Bool {
        guard !tfAreaViewModel.userInput.isEmpty, let _ = tfAreaViewModel.request?.selectedObject else {
            ToastPresenter.shared.presentToast(text: "Please select Area")
            return false
        }
        return true
    }
    
    private var isRowValid: Bool {
        guard !tfRowViewModel.userInput.isEmpty, let _ = tfRowViewModel.request?.selectedObject else {
            ToastPresenter.shared.presentToast(text: "Please select Row")
            return false
        }
        return true
    }
    
    private var isSpaceValid: Bool {
        guard !tfSpaceViewModel.userInput.isEmpty, let _ = tfSpaceViewModel.request?.selectedObject else {
            ToastPresenter.shared.presentToast(text: "Please select Space")
            return false
        }
        return true
    }
    
    private var isStartDateValid: Bool {
        return true
    }
    
    private var isEndDateValid: Bool {
        return true
    }
    
    //MARK: - Remove Previous
    private func removeLot() {
        tfLOTViewModel.userInput = ""
        tfLOTViewModel.clearModels()
        
        removeArea()
    }
    
    private func removeArea() {
        tfAreaViewModel.userInput = ""
        tfAreaViewModel.clearModels()
        
        removeRow()
    }
    
    private func removeRow() {
        tfRowViewModel.userInput = ""
        tfRowViewModel.clearModels()
        
        removeSpace()
    }
    
    private func removeSpace() {
        tfSpaceViewModel.userInput = ""
        tfSpaceViewModel.clearModels()
    }
    
    //MARK: - Clear
    private func clearAllViewData() {
        //        self.porLocations = []
        //        self.previousLocations = nil
        
        self.removeLot()
        //        self.updateCurrentDateTime()
        self.startDate = Date()
        self.startTime = Date()
    }
}

//MARK: - API
extension PORLocationViewModel {
    
    func getVinDetails (_ serial: String, barcodeUnique: String) {
        
        let params: [String: Any] = ["userId": kUserId,
                                     "userCompanyDetailId":  kUserDetails.companyId ?? "",
                                     "vin": serial,
                                     ScanKey.barcodeUnique.rawValue: barcodeUnique]
        
        ProgressPresenter.shared.showProgress()
        Task {
            let result = await PORLocationAPI.instance.fetch(with: params)
            ProgressPresenter.shared.hideProgress()
            switch result {
            case .success(let success):
                self.porLocations = success
                if !self.porLocations.isEmpty {
                    DispatchQueue.main.async {
                        self.getPreviousVinDetails()
                    }
                }
            case .failure(_):
                self.porLocations = []
            }
        }
    }
    
    private func getPreviousVinDetails() {
        let params: [String: Any] = ["cargoId": self.porLocation?.cargoId ?? "",
                                     "shipmentDetailsId": self.porLocation?.shipmentDetailId?.stringValue ?? ""]
        
        ProgressPresenter.shared.showProgress()
        Task {
            let result = await PORLocationAPI.instance.fetchPreviousVins(with: params)
            ProgressPresenter.shared.hideProgress()
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.previousLocations = success
                    self.updateLotValues()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func updatePORLocation() {
        guard allFieldsValidated else {
            return
        }
        let companyId = tfLOTViewModel.request?.selectedObject?.params?["CompanyId"]?.stringValue ?? ""
        let storageId = tfAreaViewModel.request?.selectedObject?.params?["id"]?.stringValue ?? ""
        let rowId = tfRowViewModel.request?.selectedObject?.params?["id"]?.stringValue ?? ""
        let columnId = tfSpaceViewModel.request?.selectedObject?.params?["id"]?.stringValue ?? ""
        
        let storageDateTime = [self.startDate.string(of: "yyyy-MM-dd"), self.startTime.string(of: "HH:mm:ss")].joined(separator: " ")
        
        let params: [String: Any] = ["userId": kUserId,
                                     "cargoId": porLocation?.cargoId ?? 0,
                                     "companyId": companyId,
                                     "storageId": storageId,
                                     "rowId": rowId,
                                     "columnId": columnId,
                                     "shipmentDetailId": self.porLocation?.shipmentDetailId ?? 0,
                                     "storageDate": storageDateTime,
                                     "backupLOT": self.porLocation?.backupLOT ?? "",
                                     "backupStorageDate": self.porLocation?.backupStorageDate ?? "",
                                     "backupStorageLocation": self.porLocation?.backupStorageLocation ?? ""]
        
        ProgressPresenter.shared.showProgress()
        Task {
            let result = await PORLocationAPI.instance.update(with: params)
            ProgressPresenter.shared.hideProgress()
            switch result {
            case .success(let success):
                if success {
                    //clear All fields
                    self.clearAllViewData()
                }
            case .failure(_):
                self.porLocations = []
                self.previousLocations = nil
            }
        }
        
    }
}
