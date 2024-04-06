//
//  ScanKey.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 15/03/24.
//

import Foundation

enum ScanKey: String {
    case cargoId = "cargoId"
    case salesOrder = "salesOrder"
    case outBoundBOL = "outBoundBOL"
    case msoid = "msoNum"
    case itomnumber = "itomnumber"
    case modelyear = "modelYear"
    case configuration = "configuration"
    case barcodeUnique = "barcodeUniqueSeq"
    case witem = "witemNum"
}

extension ScanKey {
    var lowerCased: String {
        rawValue.lowercased()
    }
}

extension String {
    var scanKey: ScanKey {
        switch self.lowercased() {
        case "cargoid": return .cargoId
        case "salesorder": return .salesOrder
        case "outboundbol": return .outBoundBOL
        case "msoid" : return .msoid
        case "itomnumber" : return .itomnumber
        case "modelyear" : return .modelyear
        case "configuration" : return .configuration
        case "barcodeuniqueseq" : return .barcodeUnique
        default: return .cargoId
        }
    }
}
