//
//  AppInterfaceConstants.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 15/03/24.
//

import Foundation
import OneSolutionAPI

var kUserDetails: UserDetails {
    UserData.shared.user.userDetails
}

var kUserId: Int {
    UserData.shared.user.userID ?? 0
}

var enableSearchForSerial: Bool {
    true
//    kUserDetails.enableManualSerialSearch ?? false
}

var enableImageEditing: Bool {
    kUserDetails.enableAustraliaAnnotation ?? false
}

var enableForAustralia: Bool {
    kUserDetails.enableAustraliaFieldsInMobile ?? false
}

var enableManualSerialSearch: Bool {
    kUserDetails.enableManualSerialSearch ?? false
}

var isExternalUser: Bool {
    kUserDetails.isExternalUser ?? false
}

let kUserDefaults = UserDefaults.standard
