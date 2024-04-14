//
//  File.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 30/09/23.
//

import Foundation
import OneSolutionUtility
import OneSolutionAPI


@available(iOS 14.0, *)
extension ProcessWorkOrderView {    
//    func getWorkOrders (referenceName: String = ScanKey.cargoId.rawValue,
//                        barcodeUnique: String = "",
//                        searchText: String = "",
//                        serviceGroupId: Int = 0,
//                        page: Int = 0,
//                        companyId:Int = 0,
//                        methodId:Int = 0) async {
//        
//        let params = NSMutableDictionary ()
//        params.setValue(referenceName, forKey: "referenceName")
//        params.setValue(searchText, forKey: "refSearchTxt")
//        params.setValue(serviceGroupId, forKey: "epcServiceGroupId")
//        params.setValue(page*viewModel.pageLimit, forKey: "fromRecord")
//        params.setValue(viewModel.pageLimit, forKey: "toRecord")
//        params.setValue(barcodeUnique, forKey: ScanKey.barcodeUnique.rawValue)
//        params.setValue(viewModel.tfEstDateViewModel.userInput, forKey: "expectedDate")
//        params.setValue(companyId, forKey: "companyId")
//        params.setValue(methodId, forKey: "methodId")
//                
//                
//        if let path = Bundle.main.path(forResource: "WorkoderResponse", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                do {
//                    let jsonResult = try JSONDecoder().decode(WorkOrderModel.self, from: data)
//                    self.viewModel.workOrders = jsonResult.workOrders
//                } catch let error1 {
//                    print(log: error1.localizedDescription)
//                }
//                // do stuff
//            } catch let error {
//                // handle error
//                print(log: error.localizedDescription)
//            }
//        }
//        
        
        
//        ProgressPresenter.shared.showProgress()
//        switch await ProcessWorkOrderAPI.instance.fetchWorkOrders(with: params as? [String: Any]) {
//        case .success(let models):
//            self.workOrders = models
//            break
//        case .failure(let error):
//            print(log: error.localizedDescription)
//        }
//        ProgressPresenter.shared.hideProgress()
        
//        _ = sharedNetworking.POST_request(url: ServiceAPI.shared.URL_WorkOrder_NewOrders, parameters: params, userInfo: nil, success: { [weak self] (json, response) in
//            guard let strongSelf = self else { return }
//            print(json ?? "")
//            let result = json as! NSDictionary
//            if (result.allKeys as! [String]).contains("Data") {
//                strongSelf.arrWorkOrders.removeAll()
//                strongSelf.arrWorkOrdersExpanded.removeAll()
//                for value in result.value(forKey: "Data") as! [NSDictionary] {
//                    let workOrder = WorkOrder (dict: value)
//                    workOrder.barcodeUnique = barcodeUnique
//                    strongSelf.arrWorkOrders.append (workOrder)
//                }
//                let pages = (result.value(forKey: "totRecords") as? NSNumber ?? 0).intValue
//
//                if pages%strongSelf.pageLimit == 0 {
//                    strongSelf.collectionPagesCount = pages/strongSelf.pageLimit
//                }else {
//                    strongSelf.collectionPagesCount = pages/strongSelf.pageLimit + 1
//                }
//
//                if strongSelf.collectionPagesCount > 0 {
//                    strongSelf.showServiceTable()
//                }else {
//                    strongSelf.hideServiceTable()
//                }
//
//                if strongSelf.selectedPage > (strongSelf.collectionPagesCount) {
//                    strongSelf.selectedPage = strongSelf.collectionPagesCount
//                }
//            }
//            strongSelf.collectionView.reloadData()
//            strongSelf.tableWorkOrders.reloadData()
//            if strongSelf.arrWorkOrders.count == 0 {
//
//                strongSelf.tableWorkOrders.setEmptyMessage("No Work Orders found", textColor: UIColor.black, bgColor: UIColor.clear)
//            }else {
//
//                strongSelf.tableWorkOrders.setContentOffset(CGPoint (x: 0, y: 0), animated: true)
//                strongSelf.tableWorkOrders.setEmptyMessage("", textColor: UIColor.black, bgColor: UIColor.clear)
//            }
//            strongSelf.hideServiceTable()
//            if searchText.count > 0 {
//                strongSelf.collectionHeight.constant = 0
//            }
//
//            //            if (self.tfReference.requestResponseObject?.selectedObject?.name ?? "").count > 0 || self.serialNum
//
//            //            if serialNumber.count > 0 || serviceId > 0 {
//            //                self.collectionHeight.constant = 0
//            //            }
//
//
//        }, errorblock: { [weak self] (error, isJsonError) in
//            guard let strongSelf = self else { return }
//
//            if strongSelf.arrWorkOrders.count == 0 {
//                strongSelf.tableWorkOrders.setEmptyMessage("No Work Orders found", textColor: UIColor.black, bgColor: UIColor.clear)
//            }else {
//                strongSelf.tableWorkOrders.setContentOffset(CGPoint (x: 0, y: 0), animated: true)
//                strongSelf.tableWorkOrders.setEmptyMessage("", textColor: UIColor.black, bgColor: UIColor.clear)
//            }
//
//        }, progress: nil)
        
//    }
}
