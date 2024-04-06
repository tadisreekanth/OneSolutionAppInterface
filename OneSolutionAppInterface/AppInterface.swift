//
//  AppInterface.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI

class SafeArea: ObservableObject {
    @Published var insets: UIEdgeInsets?
}

public struct AppInterface: View {
    @ObservedObject var user = UserData.shared.user
    @ObservedObject var toastPresenter = ToastPresenter.shared
    @ObservedObject var progressPresenter = ProgressPresenter.shared
    @ObservedObject var safeArea = SafeArea()
    
    public init () { }
    
    public var body: some View {
        if let userId = user.userID, userId > 0 {
            HomeView(userRoles: user.userDetails.userRoles)
                .background(Color.clear)
                .toast(presented: $toastPresenter.isPresented, text: toastPresenter.text ?? "")
                .progress(progressCount: $progressPresenter.progressCount, text: progressPresenter.text ?? "")
                .environmentObject(user)
                .environmentObject(safeArea)
                .onAppear {
                    updateSafeArea()
                }
        } else {
            LoginView()
                .toast(presented: $toastPresenter.isPresented, text: toastPresenter.text ?? "")
                .progress(progressCount: $progressPresenter.progressCount, text: progressPresenter.text ?? "")
                .environmentObject(user)
                .environmentObject(safeArea)
                .onAppear {
                    updateSafeArea()
                }
        }
    }
    
    private func updateSafeArea() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        self.safeArea.insets = windowScene.windows.first?.safeAreaInsets ?? .zero
    }
}

struct AppInterface_Previews: PreviewProvider {
    static var previews: some View {
        AppInterface()
    }
}
