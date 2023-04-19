//
//  HabitRabbitApp.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-18.
//

import SwiftUI
import FirebaseCore



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
      FirebaseApp.configure()

    return true
  }
}


@main
struct HabitRabbitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
