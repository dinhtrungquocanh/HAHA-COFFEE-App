//
//  MainView_Viet.swift
//  newHAHACOFFEE
//
//  Created by Phương An on 23/09/2024.
//
/*
import SwiftUI
import FirebaseFirestore

struct MainView_Viet: View {
    @State var selectedTab: String = "home"  // Removed `selectedRecom`
    @FirestoreQuery(collectionPath: "User") var users: [User]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                List {
                    ForEach(users) { user in
                        Text(user.name)
                    }
                }
                LandingPage()
                    .environmentObject(ModelData())
                    .tag("home")
                Color.pink
                    .tag("cup")
                Color.yellow
                    .tag("qrcode")
                CartView()
                    .environmentObject(CartStore())
                    .id(UUID())
                    .tag("cart")
            }
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .onAppear {
            // Move appearance changes to onAppear to avoid thread issues in init
            UITabBar.appearance().isHidden = true
        }
    }
}

struct MainView_Viet_Previews: PreviewProvider {
    static var previews: some View {
        MainView_Viet()
            .environmentObject(ModelData())
    }
}
 */

import SwiftUI
import FirebaseFirestore

struct MainView_Viet: View {
    @State var selectedTab: String = "home"  // Current tab selection
    @EnvironmentObject var cartManager: CartStore
    @FirestoreQuery(collectionPath: "User") var users: [User]

    var body: some View {
        VStack(spacing: 0) {
            // Render views based on the selected tab
            Group {
                switch selectedTab {
                case "home":
                    LandingPage()
                        .environmentObject(ModelData())
                case "menu":
                    MenuView()
                        .environmentObject(ModelData())
                case "qrcode":
                    Color.yellow
                case "cart":
                    CartView()
                        .id(cartManager.cartItems.count)
                        .environmentObject(cartManager)
                default:
                    Text("Unknown Tab")
                }
            }
            .transition(.opacity) // Optional: Smooth transition when switching tabs
            .animation(.easeInOut, value: selectedTab)
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .onAppear {
            // Hide the native TabBar
            UITabBar.appearance().isHidden = true
        }
    }
}

struct MainView_Viet_Previews: PreviewProvider {
    static var previews: some View {
        MainView_Viet()
            .environmentObject(ModelData())
            .environmentObject(CartStore())
    }
}
