//
//  RootView.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//

/*

import Foundation
import SwiftUI

struct RootView: View {
    @EnvironmentObject var authviewModel: AuthViewModel
    @State private var loginSource: String? = nil // Tracks the source of login

    var body: some View {
        NavigationView {
            Group {
                if !authviewModel.isLanguageSelected {
                    ContentView()
                } else if let role = authviewModel.role, authviewModel.userSession != nil {
                    if role == "customer" {
                        customerNavigation(for: loginSource)
                    } else {
                        roleBasedView(for: role)
                    }
                } else {
                    MainView_Viet()
                }
            }
            .navigationBarHidden(true)
            .onChange(of:authviewModel.userSession) { userSession in
                // Handle logout by resetting language selection
                if userSession == nil {
                    authviewModel.resetToContentView()
                }
            }
        }
    }

    @ViewBuilder
    private func customerNavigation(for source: String?) -> some View {
        switch source {
        case "profile":
            ProfileView()
        case "cart":
            CartView()
        default:
            MainView_Viet()
        }
    }

    @ViewBuilder
    private func roleBasedView(for role: String) -> some View {
        switch role {
        case "admin":
            AdminView()
        case "shipper":
            ShipperView()
        case "staff":
            StaffView()
        default:
            MainView_Viet()
        }
    }
}
*/
