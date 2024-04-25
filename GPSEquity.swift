//
//  GPSEquity.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/13/24.
//

import SwiftUI
import XCAStocksAPI
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct GPSEquity: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var appVM = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainListView()
            }
            .environmentObject(appVM)
        }
    }
}
