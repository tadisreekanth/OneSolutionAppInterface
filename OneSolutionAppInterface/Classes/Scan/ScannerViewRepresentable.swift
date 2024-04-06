//
//  Scanner.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 09/03/24.
//

import SwiftUI
import AVFoundation

struct ScannerViewRepresentable: UIViewControllerRepresentable {
    
    let viewController = UIViewController()
    let session = AVCaptureSession()
    let previewLayer: AVCaptureVideoPreviewLayer?
    var coordinator: ScannerViewCoordinator
    var codeView = UIView()
    
    
    init(onReceiveScannedResponse: @escaping (String?) -> Void) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        coordinator = ScannerViewCoordinator(onReceiveScannedResponse: onReceiveScannedResponse,
                                             codeView: codeView,
                                             previewLayer: previewLayer)        
    }
        
    func makeUIViewController(context: Context) -> UIViewController {
        return self.scanlayer(with: context)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension ScannerViewRepresentable {
    
    private func scanlayer(with context: Context) -> UIViewController {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }
        
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            return viewController
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = scannerSupportedCodeTypes
        } else {
            return viewController
        }
        
        previewLayer?.frame = viewController.view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let layer = previewLayer {
            viewController.view.layer.addSublayer(layer)
        }
        
        if #available(iOS 14.0, *) {
            codeView.layer.borderColor = Color.app_green.uiColor.cgColor
        } else {
            // Fallback on earlier versions
            codeView.layer.borderColor = UIColor.green.cgColor
        }
        codeView.layer.borderWidth = 2
        
        DispatchQueue.global().async {
            session.startRunning()
        }
    
        return viewController
    }
}

    
class ScannerViewCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    private var result: ((String?) -> Void)
    private var codeView: UIView
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(onReceiveScannedResponse: @escaping (String?) -> Void,
         codeView: UIView,
         previewLayer: AVCaptureVideoPreviewLayer? = nil) {
        self.result = onReceiveScannedResponse
        self.codeView = codeView
        self.previewLayer = previewLayer
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            codeView.frame = .zero
            self.result(nil)
            return
        }
        
        // Get the metadata object.
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            result(nil)
            return
        }
            
        if scannerSupportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            if let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj) {
                codeView.frame = barCodeObject.bounds
            }
            
            if metadataObj.stringValue != nil {
                if let str = metadataObj.stringValue {
                    self.result(str)
                }else {
                    self.result("")
                }
            }
        }
    }
}
     
private var scannerSupportedCodeTypes: [AVMetadataObject.ObjectType] {
    [.upce,
     .code39,
     .code39Mod43,
     .code93,
     .code128,
     .ean8,
     .ean13,
     .aztec,
     .pdf417,
     .itf14,
     .dataMatrix,
     .interleaved2of5,
     .qr
    ]
}
