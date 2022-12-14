//
//  MedCheckApp.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 29/11/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct MedCheckApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(SignUpViewModel())
                .preferredColorScheme(.light)
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url)
    }
}
