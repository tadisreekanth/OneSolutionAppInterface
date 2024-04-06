//
//  ScannerView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 09/03/24.
//

import SwiftUI
import OneSolutionUtility

typealias ScanResponse = ([ScanKey: Any]?, String) -> Void

struct ScannerView: View {
    @State private var scannedCode: String?
    
    private var isUnlimitedScan: Bool
    private var scanTypes: [ScanKey]?
    
    private var onClose: () -> Void
    private var onReceiveScanResponse: ScanResponse?
    
    init(isUnlimitedScan: Bool = false,
         scanTypes: [ScanKey]? = nil,
         onReceiveScanResponse: ScanResponse? = nil,
         onClose: @escaping () -> Void) {
        self.isUnlimitedScan = isUnlimitedScan
        self.onReceiveScanResponse = onReceiveScanResponse
        self.onClose = onClose
    }
    
    var body: some View {
        VStack {
            
            //header
            headerView
            
            //scanner View
            ScannerViewRepresentable { str in
                self.scannedCode = str
                self.receivedScannedResponse()
            }
            
            //Label
            if let scannedCode = scannedCode {
                Text("Scanned code: \(scannedCode)")
            } else {
                Text("No Code Detected")
            }
        }
    }
    
    private var headerView: some View {
        HStack (spacing: 8.0) {
            Button {
                onClose()
            } label: {
                AssetIcon.close.image
                    .frame(width: 30, height: 30)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Text("Scan")
                .font(.system(size: appFont16))
                .foregroundColor(.app_white)
            
            Spacer()
            
            Button {
                
            } label: {
                Text(isUnlimitedScan ? "" : "Stop")
                    .font(.system(size: appFont12))
                    .foregroundColor(.app_separator1)
            }
            .padding(.trailing, 8)
        }
        .minimumHeight()
        .background(Color.app_separator)
    }
}

extension ScannerView {
    func receivedScannedResponse() {
        //do filterations here
        guard let scannedCode, scannedCode.contains("{") else {
            showToastMessage()
            return
        }
        guard let data = scannedCode.data(using: .utf8) else {
            showToastMessage()
            return
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            showToastMessage()
            return
        }
        let json = jsonObject.lowerCasedKeysJson
        
        var result: [ScanKey: Any] = [:]
        
        self.scanTypes?.forEach({ key in
            result[key] = json[key.lowerCased] ?? ""
        })
        
        if result.keys.contains(ScanKey.barcodeUnique), result[ScanKey.barcodeUnique] == nil {
            showToastMessage()
        } else {
            onReceiveScanResponse?(result, "")
        }
    }
}

extension ScannerView {
    func showToastMessage () {
        
        guard let scanTypes = scanTypes else {
            onReceiveScanResponse?(nil, "")
            return
        }
        switch scanTypes.first {
        case .salesOrder:
            onReceiveScanResponse?(nil, "Please add sales order number in the inventory for the serial #")
        case .cargoId:
            onReceiveScanResponse?(nil, "Please add serial # in the inventory")
        case .outBoundBOL:
            onReceiveScanResponse?(nil, "Please add out bound BOL number in the inventory for the serial #")
        default:
            onReceiveScanResponse?(nil, "No codes found")
        }
    }
}

#Preview {
    ScannerView { scannedResponse, errorMessage in
        if !errorMessage.isEmpty {
            ToastPresenter.shared.presentToast(text: errorMessage)
        }
    } onClose: {
        
    }

}
