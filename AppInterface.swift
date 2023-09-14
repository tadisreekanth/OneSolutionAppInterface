//
//  AppInterface.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI

public struct AppInterface: View {
    @EnvironmentObject public var user: UserBean

    public init () { }
    
    public var body: some View {
        if let userId = user.userID, userId > 0 {
            HomeView(userRoles: user.userDetails.userRoles)
                .environmentObject(user)
                .background(Color.clear)
        } else {
            LoginView()
                .environmentObject(user)
        }
    }
}

struct AppInterface_Previews: PreviewProvider {
    static var previews: some View {
        AppInterface()
    }
}
