//
//  spy_appApp.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import SwiftUI
import Firebase

@main
struct spy_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    //init() {
        //FirebaseApp.configure()
    //}
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel.shared)
        }
    }
}

class AppDelegate: NSObject,UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async ->
    UIBackgroundFetchResult {
        return .noData
    }
}
