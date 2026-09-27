//
//  HAHACOFFEEApp.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 22/10/2024.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
        
        FirebaseApp.configure()

        return true
    }
}

@main
struct HAHACOFFEEApp: App {
    // register app delegate for Firebase setup
    @StateObject var dataManager = DataManager()
    @StateObject var cartStore = CartStore()
    @StateObject private var modelData = ModelData()
    // @StateObject private var cartManager = CartManger()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var languageSettings = LanguageSetting()
    @StateObject var viewModel = AuthViewModel()
    @StateObject var latnlon = LatnLon()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, languageSettings.locale)
                .environmentObject(cartStore)
                .environmentObject(languageSettings)
                .environmentObject(viewModel)
                .environmentObject(modelData)
                .environmentObject(latnlon)
        }
    }
}
