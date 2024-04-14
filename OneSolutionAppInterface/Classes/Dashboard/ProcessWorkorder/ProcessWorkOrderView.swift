//
//  ProcessWorkOrderView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 30/09/23.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI
import OneSolutionTextField

@available(iOS 14.0, *)
struct ProcessWorkOrderView: View {
    @ObservedObject var viewModel: ProcessWorkOrderViewModel
    
    @State var footerScrollOffset: CGFloat = 0
    
    
    init(viewModel: ProcessWorkOrderViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        OneSolutionBaseView {
            HeaderView(back: (true, {
                self.viewModel.showSelf = ""
            }), home: (true, {
                self.viewModel.showSelf = ""
            }), title: "Process WorkOrder")
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    topView
                    
                    workordersView
                }
                .padding(.horizontal, 10)
            }
            Spacer()
            
            ///FOOTER
            footerView
        }
        .onAppear {
            updateTextFieldsValues()
            
            viewModel.getWorkOrders()
        }
    }
}

@available(iOS 14.0, *)
extension ProcessWorkOrderView {
    
    var topView: some View {
        Section {
            VStack {
                VStack (alignment: .leading, spacing: 5) {
                    Text("Reference")
                    OneSolutionTextField(
                        viewModel: viewModel.tfReferenceViewModel
                    )
                    OneSolutionTextField(
                        viewModel: viewModel.tfSerialViewModel
                    )
                }
                HStack {
                    Text("Site")
                    OneSolutionTextField(
                        viewModel: viewModel.tfSiteViewModel
                    )
                }
                HStack {
                    Text("Service Group")
                    OneSolutionTextField(
                        viewModel: viewModel.tfServiceGroupViewModel
                    )
                }
                HStack {
                    Text("Method Out")
                    OneSolutionTextField(
                        viewModel: viewModel.tfMethodOutViewModel
                    )
                }
                HStack {
                    Text("Est Date #")
                    OneSolutionTextField(
                        viewModel: viewModel.tfEstDateViewModel
                    )
                }
            }
        }
        .hideRowSeparator()
        .background(Color.clear)
    }
    
    var workordersView: some View {
        //        LazyVGrid(columns: [GridItem()]) {
        if let workOrders = viewModel.workOrders {
            return AnyView(ForEach (workOrders, id:\.uuid) { item in
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        if self.viewModel.expandedList.contains(item), let childs = item.childs {
                            ForEach(childs, id:\.uuid) { child in
                                let text = self.workOrderChildText(with: child, workOrder: item)
                                HStack {
                                    HStack() {
                                        Text(text)
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.app_white)
                                    .cornerRadius(5)
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                } header: {
                    let isExpanded = self.viewModel.expandedList.contains(item)
                    WorkOrderHeader(workorder: item, openAction: {
                        
                    }, checkListAction: {
                        
                    }, expandAction: {
                        if self.viewModel.expandedList.contains(item) {
                            self.viewModel.expandedList.remove(item)
                        } else {
                            self.viewModel.expandedList.insert(item)
                        }
                    }, isExpanded: isExpanded)
                    .whiteBackground()
                    .padding(.bottom, isExpanded ? 0 : 5)
                }
            }
                           //        }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var footerView: some View {
        HStack (spacing: 5) {
            AssetIcon.left_arrow.image
                .frame(maxWidth: 22, maxHeight: 22, alignment: .leading)
                .onTapGesture {
                    
                }
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(1..<30) { i in
                            Button {
                                viewModel.onFooterPageSelected(index: i)
                            } label: {
                                Text("\(i)")
                                    .basicWidth()
                                    .frame(height: 30)
                                    .background(Color.app_white)
                                    .cornerRadius(viewCornerRadius)
                                    .onAppear {
                                        print("visible index \(i)")
                                    }
                            }
                        }
                    }
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onChange(of: geometry.frame(in: .global).minY) { newValue in
                                    footerScrollOffset = newValue
                                    // Perform actions based on scroll position change
                                    print("New scroll offset: \(newValue)")
                                }
                        }
                    )
                }
                .basicHeight()
            }
            
            AssetIcon.right_arrow_green.image
                .frame(maxWidth: 22, maxHeight: 22, alignment: .trailing)
                .onTapGesture {
                    
                }
        }
    }
    
    //MARK: Helper
    private func workOrderChildText(with item: WorkOrderChild,
                                    workOrder: WorkOrder) -> String {
        let serial = (item.serialNum ?? "")
        let service = item.serviceStatus ?? ""
        
        let dealer = "Dealer - \(item.dealerName ?? "")"
        
        var textArray: [String] = [
            "SN# - \(serial) ( \(service) )",
            "Service Name - \(item.serviceNum ?? "")",
            "Description - \(item.descriptionWOChild ?? "")",
            "Customer - \(item.customer ?? "")",
            "ETA# - \(item.expectedDate ?? "")",
            dealer, //need to add attributed text
            "Mount Model# - \(item.mountModel ?? "")",
            "Mount Description# - \(item.mountModelDescription ?? "")",
            "Mount SN# - \(item.mountSerialNo ?? "")",
            "Mount Location - \(item.mountLocation ?? "")",
            "Part SN# - \(item.partSerialNumber ?? "")",
            "Part MSO - \(item.partMso ?? "")",
            "Part Witem - \(item.partWItem ?? "")"
        ]
        
        if !(item.instructions ?? "").isEmpty {
            textArray.append("Instruction Lines - \(item.instructions ?? "")")
        }
        if !(item.putBackSerialNumber ?? "").isEmpty {
            textArray.append("Put Back SN# - \(item.putBackSerialNumber ?? "")")
        }
        
        if workOrder.checkListFlag == false {
            let estimatedTimeText = "Estimated time : " + (item.workOrderTime?.tpaTime ?? "")
            let actualTimeText = "Actual time : " + (item.workOrderTime?.actualTime ?? "")
            
            var timerText = dealer
            timerText = timerText + "\n" + estimatedTimeText
            timerText = timerText + "\n" + actualTimeText
            
            let defaultColor: UIColor = .gray
            let timeColor = item.workOrderTime?.timeColor
            let color = timeColor == .black ? defaultColor : (timeColor ?? .black)
            
            let attStr = NSMutableAttributedString.attributetitleFor(title: timerText,
                                                                     rangeStrings: [timerText, actualTimeText],
                                                                     colors: [defaultColor, color],
                                                                     fonts: [UIFont.systemFont(ofSize: 14), UIFont.systemFont(ofSize: 14)],
                                                                     alignmentCenter: false)
            if let index = textArray.firstIndex(of: dealer) {
                textArray[index] = attStr.string
            }
        }
        return textArray.joinedLine
    }
    
}

@available(iOS 14.0, *)
extension ProcessWorkOrderView {
    
    var serviceGroupParams: NSDictionary {
        let params = NSMutableDictionary ()
        params.setValue(UserData.shared.user.userID ?? 0, forKey: "userId")
        return params
    }
    
    func updateTextFieldsValues() {
        //
        //        tfReference.updateRequest(request: OneSolutionRequest(url_String: ServiceAPI.shared.URL_LoadOut_Reference, requestParams: serviceGroupParams, searchValueKey: ""))
        //        tfSerial.updateRequest(request: OneSolutionRequest(url_String: ServiceAPI.shared.URL_LoadOut_Reference, requestParams: serviceGroupParams, searchValueKey: ""))
        //        tfServiceGroup.updateRequest(request: OneSolutionRequest(url_String: ServiceAPI.shared.URL_LoadOut_Reference, requestParams: serviceGroupParams, searchValueKey: ""))
        //        tfEstDate.updateRequest(request: OneSolutionRequest(url_String: ServiceAPI.shared.URL_LoadOut_Reference, requestParams: serviceGroupParams, searchValueKey: ""))
        //
        //        tfReference.onTextChange = {
        //
        //        }
        //        tfReference.onAPIResponse = { response in
        //
        //        }
        //        tfReference.onSelected = { selected in
        //
        //        }
    }
}

@available(iOS 14.0, *)
struct WorkOrderHeader: View {
    var workorder: WorkOrder
    var openAction: EmptyParamsHandler?
    var checkListAction: EmptyParamsHandler?
    var expandAction: EmptyParamsHandler?
    var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.app_green)
                            .frame(width: 50, height: 50)
                            .cornerRadius(2)
                        Text(self.isExpanded ? "-" : "+")
                            .foregroundColor(.app_white)
                            .font(.system(size: 20))
                    }
                    .onTapGesture {
                        self.expandAction?()
                    }
                    VStack {
                        Text(workOrderText)
                            .font(.system(size: appFont15))
                            .foregroundColor(Color.app_black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                        //                            .frame(alignment: .leading)
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Open")
                        .foregroundColor(.app_blue)
                        .font(.system(size: 14))
                        .onTapGesture {
                            self.openAction?()
                        }
                }
            }
        }
    }
    
    //MARK: Helper
    
    var workOrderText: String {
        var textArray: [String] = []
        
        if let servicenum = workorder.serviceNum {
            textArray.append("WO - " + (workorder.serviceGroup ?? "") + "  " + servicenum)
        }
        
        if let serialNumber = workorder.serialNum {
            textArray.append("SN# - " + serialNumber)
        }
        
        var porText = ""
        if let storage = workorder.storageName,
           !storage.isEmpty {
            porText = "POR# - " + storage
        }else {
            porText = "POR# - " + "N/A"
        }
        
        if workorder.checkListFlag ?? false {
            
            let estimatedTimeText = "Estimated time : " + (workorder.workOrderTime?.tpaTime ?? "")
            let actualTimeText = "Actual time : " + (workorder.workOrderTime?.actualTime ?? "")
            
            var modifiedPORText = porText
            modifiedPORText = modifiedPORText + "\n" + estimatedTimeText
            modifiedPORText = modifiedPORText + "\n" + actualTimeText
            
            let defaultColor: UIColor = .gray
            let timeColor = workorder.workOrderTime?.timeColor
            let color = timeColor == .black ? defaultColor : (timeColor ?? .black)
            
            
            let attStr = NSMutableAttributedString.attributetitleFor(title: modifiedPORText,
                                                                     rangeStrings: [modifiedPORText, actualTimeText],
                                                                     colors: [defaultColor, color],
                                                                     fonts: [UIFont.systemFont(ofSize: 14), UIFont.systemFont(ofSize: 14)],
                                                                     alignmentCenter: false)
            
            if let index = textArray.firstIndex(of: porText) {
                textArray[index] = attStr.string
            }
        } else {
            
            textArray.append(porText)
        }
        
        return textArray.joinedLine
    }
}
