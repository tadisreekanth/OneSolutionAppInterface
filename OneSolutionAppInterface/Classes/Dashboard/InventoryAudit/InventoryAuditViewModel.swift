//
//  InventoryAuditViewModel.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 28/03/24.
//

import Foundation
import OneSolutionUtility
import OneSolutionTextField
import OneSolutionAPI
import SwiftUI

enum InventoryAuditFunction {
    case started
    case stop
    case paused
    case resumed
    case completed
    case undefined
    
    var startIconAsset: (AssetIcon, String) {
        switch self {
        case .started, .paused, .resumed: 
            return (AssetIcon.started, self == .started ? "Started" : "Start")
        default: return (AssetIcon.start, "Start")
        }
    }
    
    var pauseIconAsset: (AssetIcon, String) {
        switch self {
        case .paused: 
            return (AssetIcon.resume, "Resume")
        default : return (AssetIcon.pause, "Pause")
        }
    }
    
    var completeIcon: AssetIcon {
        switch self {
        case .started, .paused, .resumed:
            return .stop
        default : return .stop_disabled
        }
    }
}

class InventoryAuditViewModel: ObservableObject {
    
    @Binding var showSelf: String?

    @Published var tfSiteGroupViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var showExitAlert: Bool = false
    @Published var showSettingsAlert: Bool = false
    @Published var showScanView: Bool = false
    @Published var showSettings: Bool = false

    var inventoryFunction: InventoryAuditFunction = .undefined
    var startTime: String?
    var arrScanSerials: [Inventaroy] = []

    init(showSelf: Binding<String?>) {
        
        self._showSelf = showSelf
        
        self.initializeSiteGroup()
        
        if !alertMessage.isEmpty {
            showSettingsAlert = true
        }
    }
}

//MARK: - Helper
extension InventoryAuditViewModel {
    private var endPoints: InventoryAuditPath? {
        APIClient.shared?.path?.inventoryAudit
    }
    
    var alertMessage: String {
        let vibrate = (kUserDefaults.object(forKey: Settings.vibrate.rawValue) as? Bool) ?? false
        let sound = (kUserDefaults.object(forKey: Settings.sound.rawValue) as? Bool) ?? false

        if !sound, !vibrate {
            return "Scanning Sound and Vibration are Disabled\nYou can Enable by tapping Settings icon."
        }else if !sound {
            return "Scanning Sound is Disabled\nYou can Enable by tapping Settings icon."
        }else if !vibrate {
            return "Scanning Vibration is Disabled\nYou can Enable by tapping Settings icon."
        }
        return ""
    }
    
    var scanTypes: [ScanKey] {
        [.cargoId, .barcodeUnique, .witem]
    }
    
    private func vibrateAndPlaySound () {
        let vibrate = (kUserDefaults.object(forKey: Settings.vibrate.rawValue) as? Bool) ?? false
        let sound = (kUserDefaults.object(forKey: Settings.sound.rawValue) as? Bool) ?? false
                
        if vibrate {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIDevice.vibrateSuccess()
            }
        }
        if sound {
            UIDevice.playSound(fileName: "success", type: "wav")
        }
    }
}

extension InventoryAuditViewModel {
    
    private func initializeSiteGroup() {
        let key = "searchValue"
        let params: [String: Any] = [key: "",
                                     "userId": kUserId,
                                     "maxResults": 1000]
//        let modal = OneSolutionModal (objectId: String.checkingNull (dict.value(forKey: "siteGroupId") as Any), objectName: String.checkingNull (dict.value(forKey: "description") as Any), serviceObject: dict)

        let request = OneSolutionRequest(url_String: endPoints?.siteGroup ?? "", requestParams: params, searchValueKey: key)
        
        self.tfSiteGroupViewModel = OneSolutionTextFieldViewModel(
            input: "",
            placeholder: "Enter Site Group or choose",
            showRightView: true,
            rightIcon: .down_arrow,
            showClear: true,
            callAPIWhenTextChanged: true,
            callAPIWhenRightIconTap: true,
            request: request,
            objectType: InventaroySiteGroup.self ,
            onRightImageTap: {
                
            }, onTextChange: {
                
            }, onClearTap: {
                
            }, onAPIResponse: { data in
                
            }, onSelected: { [weak self] model in
                
                self?.tfSiteGroupViewModel.editable(false)
            })
    }
}

extension InventoryAuditViewModel {
    func saveBeforExit (toRootView: Bool) {
     
        if (self.inventoryFunction == .started || self.inventoryFunction == .resumed), self.arrScanSerials.count > 0 {
            self.showExitAlert = true
        } else {
            self.showSelf = nil
        }
    }
    
    func onScanResponseReceived(_ response: [ScanKey: Any]?) {
//        scanTypes
        if let response = response as? [ScanKey: String] {
            var scanserial = Inventaroy(
                serial: response[.cargoId],
                barcodeUnique: response[.barcodeUnique],
                witem: response[.witem]
            )
            
            if let _ = self.arrScanSerials.first(where: { $0.serial == scanserial.serial && $0.barcodeUnique == scanserial.barcodeUnique }) {
                ToastPresenter.shared.presentToast(text: "Serial# is already scanned.")
                return
            } else {
                
                ToastPresenter.shared.presentToast(text: "Serial# scanned successfully.")
                
                self.vibrateAndPlaySound()
                
                scanserial.update(date: Date ().string(of: "dd-MM-yyyy HH:mm:ss"))
                                
                arrScanSerials.append(scanserial)
                                
//                self?.savetoDefaults()
            }
        }
    }
}

//Action
extension InventoryAuditViewModel {
    func startAction() {
        if tfSiteGroupViewModel.request?.selectedObject?.id?.isEmpty ?? true {
            ToastPresenter.shared.presentToast(text: "Please select Site group")
            return
        }
        
        if inventoryFunction == .started {
            ToastPresenter.shared.presentToast(text: "Inventory already started")
        } else {
            startTime = Date().string(of: "dd-MM-yyyy HH:mm:ss")
            inventoryFunction = .started
        }
//                            self.startStopImages ()
        
//                            self.handleInventoryButtonsActions(UIButton())
    }
    
    func pauseAction() {
        if inventoryFunction != .paused {
            inventoryFunction = .paused
            self.savetoDefaults()
        } else {
            if let _ = startTime { }
            else {
                if self.arrScanSerials.count > 0 {
                    startTime = self.arrScanSerials.first?.date
                }else {
                    startTime = Date().string(of: "dd-MM-yyyy HH:mm:ss")
                }
            }
            inventoryFunction = .resumed
            //                            self.handleInventoryButtonsActions(UIButton())
        }
        //                            self.startStopImages ()
    }
    
    func completeAction() {
        if inventoryFunction == .paused {
            ToastPresenter.shared.presentToast(text: "Please resume the Inventory")
            return
        }
        
        if inventoryFunction == .started || inventoryFunction == .resumed {
            if self.arrScanSerials.isEmpty {
                ToastPresenter.shared.presentToast(text: "Please scan atleast one serial #")
            }else {
//                self.saveSerials(nil)
                self.save()
            }
        }else {
            
            ToastPresenter.shared.presentToast(text: "Please start the Inventory")
        }
        
//        self.startStopImages ()
    }
}

let kSaveInventories = "inventoryAudits"
let kSavedSitegroupId = "SavedsiteGroupId"
let kSavedSitegroup = "SavedsiteGroupName"
let kSavedStartTime = "SavedStartTime"


//MARK: - Save & Fetch
extension InventoryAuditViewModel {
    func savetoDefaults() {
        var serials = [Data]()
        let arr = self.arrScanSerials
        arr.forEach { scanSerial in
            if let json = try? JSONEncoder().encode(scanSerial) {
                serials.append(json)
            }
        }
        
        kUserDefaults.setValue(serials, forKey: kSaveInventories)
        if let id = self.tfSiteGroupViewModel.request?.selectedObject?.id,
            let name = self.tfSiteGroupViewModel.request?.selectedObject?.name {
            kUserDefaults.setValue(id, forKey: kSavedSitegroupId)
            kUserDefaults.setValue(name, forKey: kSavedSitegroup)
        }
        if let time = self.startTime {
            kUserDefaults.setValue(time, forKey: kSavedStartTime)
        }
        
        kUserDefaults.synchronize()
    }
    
    func fetchfromDefaults() {
        if let arr = kUserDefaults.value(forKey: kSaveInventories) as? [Data] {
            self.arrScanSerials = arr.reduce(into: [Inventaroy]()) { partialResult, value in
                if let scanSerial = try? value.decode(Inventaroy.self).get() {
                    partialResult.append(scanSerial)
                }
            }
            
            if self.arrScanSerials.count > 0 {
//                self.handleInventoryButtonsActions(self.btnPause)
            }
//            self.tableViewScannedSerials.reloadData()
            
//            if let siteGroup = kUserDefaults.value(forKey: kSavedSitegroupId) as? String,
//               let siteGroupName = kUserDefaults.value(forKey: kSavedSitegroup) as? String {
//                let model = OneSolutionModal(objectId: siteGroup, objectName: siteGroupName, serviceObject: NSDictionary(objects: [siteGroup, siteGroupName], forKeys: ["siteGroupId", "description"] as [NSCopying]))
//                self.tfSiteGroup.append(modal: model)
//                self.tfSiteGroup.tableView(self.tfSiteGroup.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
//            }
            if let time = kUserDefaults.value(forKey: kSavedStartTime) as? String {
                self.startTime = time
            }
        }
    }
}

//API
extension InventoryAuditViewModel {
    func save() {
        if self.arrScanSerials.isEmpty {
            ToastPresenter.shared.presentToast(text: "Please scan atleast one serial #")
            return
        }
        
        if tfSiteGroupViewModel.request?.selectedObject?.id?.isEmpty ?? true {
            ToastPresenter.shared.presentToast(text: "Please select Site group")
            return
        }
        
        var serialList = [[String: Any]]()
        for inventory in self.arrScanSerials {
            serialList.append(
                [
                    "referenceValue": inventory.serial ?? "",
                    "referenceDateTime": inventory.date ?? "",
                    "barcodeUniqueSeq": inventory.barcodeUnique ?? "",
                    "witem": inventory.witem ?? ""
                ]
            )
        }
        
        let params: [String: Any] = [
            "userId": kUserId,
            "batchName": "Inventory_Batch_\(startTime ?? "")",
            "batchDateTime": startTime ?? "",
            "siteGroupId": self.tfSiteGroupViewModel.request?.selectedObject?.id ?? "",
            "data": serialList
        ]
        
        ProgressPresenter.shared.showProgress()
        Task {
            let result = await InventoryAPI.instance.save(with: params)
            ProgressPresenter.shared.hideProgress()
            switch result {
            case .success(let success):
                if success {
                    //clear All fields
                    kUserDefaults.removeObject(forKey: kSaveInventories)
                    kUserDefaults.removeObject(forKey: kSavedSitegroup)
                    kUserDefaults.removeObject(forKey: kSavedSitegroupId)
                    kUserDefaults.synchronize()
                    
                    ToastPresenter.shared.presentToast(text: "Saved successfully")
                    inventoryFunction = .stop
                    inventoryFunction = .undefined
                    
                    self.tfSiteGroupViewModel.editable(true)
                    
                    self.tfSiteGroupViewModel.clearModels()
                    self.tfSiteGroupViewModel.update(input: "")
                    
                    self.arrScanSerials = []
                    
                }
            case .failure(let error):
                ToastPresenter.shared.presentToast(text: error.localizedDescription)
            }
        }
    }
}
