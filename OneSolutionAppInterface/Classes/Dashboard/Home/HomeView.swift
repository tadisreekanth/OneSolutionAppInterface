//
//  HomeView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 14/09/23.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject var user: UserBean
    @State var graphData: GraphData?
    var userRoles: [UserRole]?
    @State private var navigateToNextView: String? = ""
    
    var body: some View {
        NavigationView {
            OneSolutionBaseView {
                VStack {
                    HeaderView(logout: (true, {
                        user.remove()
                    }), title: "Home")
                    List {
                        if let data = graphData {
                            OneSolutionPieChartView(graphData: data)
                                .frame(height: 310)
                                .listRowBackground(Color.clear)
                        }
                        if let roles = userRoles {
                            list(with: roles)
                        }
                    }
                    .hideRowSeparator()
                    .listRowBackground(Color.clear)
                }
            }
        }
        .onAppear(perform: {
            self.fetchGraphData()
        })
    }
    
    private func list(with userRoles: [UserRole]) -> some View {
        ForEach(userRoles.filter({ $0.role?.rawValue != nil }), id: \.role?.rawValue) { role in
            let roleName = role.role ?? .process_workorder
            NavigationLink(tag: role.role?.rawValue ?? "", selection: $navigateToNextView) {
                switch roleName {
                case .process_workorder:
                    ProcessWorkOrderView(showSelf: $navigateToNextView)
                default:
                    EmptyView()
                }
            } label: {
                HomeListRow(role: role)
                    .minimumHeight()
            }
        }
        .hideRowSeparator()
        .rowWhiteBackground()
    }
    
    private func fetchGraphData() {
        if user.userDetails.isExternalUser == false {
            Task {
                switch await HomeAPI.shared.fetchGraphData() {
                case .success(let data):
                    self.graphData = data
                case .failure(_):
                    break
                }
            }
        }
    }
}

struct HomeListRow: View {
    var role: UserRole
    var body: some View {
        Text(role.displayName ?? "")
            .font(.system(size: appFont15))
            .foregroundColor(Color.app_black)
            .frame(alignment: .leading)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserBean())
    }
}