//
//  ProcessWorkOrderViewModel.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/04/24.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionTextField
import OneSolutionAPI
import Combine

class ProcessWorkOrderViewModel: ObservableObject {
    @Binding var showSelf: String?

    @Published var tfReferenceViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfSerialViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfSiteViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfServiceGroupViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfMethodOutViewModel = OneSolutionTextFieldViewModel.defaultInstance
    @Published var tfEstDateViewModel = OneSolutionTextFieldViewModel.defaultInstance
    
    @Published var collectionPagesCount: Int = 0
    @Published var selectedPage: Int = 0
    @Published var pageLimit: Int = 50
    
    @Published var expandedList: Set<WorkOrder> = []
    @Published var workOrders: [WorkOrder]?
    
    private var task: Task<Void, Never>?

    
    init(showSelf: Binding<String?>) {
        self._showSelf = showSelf
        self.initializeReference()
        self.initializeSerial()
        self.initializeSite()
        self.initializeServiceGroup()
        self.initializeMethod()
        self.initializeEstDate()
    }
}

extension ProcessWorkOrderViewModel {
    
    private func initializeReference() {
        self.tfReferenceViewModel = OneSolutionTextFieldViewModel(input: "",
                                                                  placeholder: "Please select reference",
                                                                  showRightView: true,
                                                                  rightIcon: .down_arrow,
                                                                  showClear: true)
    }
}

extension ProcessWorkOrderViewModel {
    
    private func initializeSerial() {
        self.tfSerialViewModel =  OneSolutionTextFieldViewModel(input: "",
                                                                placeholder: "SERIAL #",
                                                                showRightView: true,
                                                                rightIcon: .camera,
                                                                showClear: true,
                                                                objectType: Serial.self)
    }
}

extension ProcessWorkOrderViewModel {
    
    private func initializeSite() {
        self.tfSiteViewModel = OneSolutionTextFieldViewModel(input: "",
                                                             placeholder: "Touch here to type",
                                                             showRightView: true,
                                                             rightIcon: .down_arrow,
                                                             showClear: true)
    }
}

extension ProcessWorkOrderViewModel {
    
    private func initializeServiceGroup() {
        self.tfServiceGroupViewModel = OneSolutionTextFieldViewModel(input: "",
                                                                     placeholder: "Touch here to type",
                                                                     showRightView: true,
                                                                     rightIcon: .down_arrow,
                                                                     showClear: true)
    }
}

extension ProcessWorkOrderViewModel {
    
    private func initializeMethod() {
        self.tfMethodOutViewModel = OneSolutionTextFieldViewModel(input: "",
                                                                  placeholder: "Touch here to type",
                                                                  showRightView: true,
                                                                  rightIcon: .down_arrow,
                                                                  showClear: true)
    }
}

extension ProcessWorkOrderViewModel {
    
    private func initializeEstDate() {
        self.tfEstDateViewModel = OneSolutionTextFieldViewModel(input: "",
                                                                placeholder: "Please select Date",
                                                                showRightView: true,
                                                                rightIcon: .calender,
                                                                showClear: true)
    }
}

//MARK: - Actions
extension ProcessWorkOrderViewModel {
    func onFooterPageSelected(index: Int) {
        
    }
}

//MARK: - API
extension ProcessWorkOrderViewModel {
    func getWorkOrders (referenceName: String = ScanKey.cargoId.rawValue,
                        barcodeUnique: String = "",
                        searchText: String = "",
                        serviceGroupId: Int = 0,
                        page: Int = 0,
                        companyId:Int = 0,
                        methodId:Int = 0) {
        
        task?.cancel()
        
        let params: [String: Any] = ["referenceName": referenceName,
                                     "refSearchTxt": searchText,
                                     "epcServiceGroupId": serviceGroupId,
                                     "fromRecord": page*pageLimit,
                                     "toRecord": pageLimit,
                                     ScanKey.barcodeUnique.rawValue: barcodeUnique,
                                     "expectedDate": tfEstDateViewModel.userInput,
                                     "companyId": companyId,
                                     "methodId": methodId]
                        
        ProgressPresenter.shared.showProgress()
        Task {
            let result = await ProcessWorkOrderAPI.instance.fetchWorkOrders(with: params)
            ProgressPresenter.shared.hideProgress()
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.workOrders = success
                }
            case .failure(let error):
                switch error {
                case .errorMessage(let message):
                    if message.lowercased() != "cancelled" {
                        ToastPresenter.shared.presentToast(text: message)
                        self.workOrders = nil
                    }
                default:
                    break
                }
            }
        }
    }
}
