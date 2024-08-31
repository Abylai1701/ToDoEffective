//
//  AppDelegate.swift
//  AutoEasy
//
//  Created by Abylaikhan Abilkayr on 12.05.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        let vc = MainBuilder.build()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}
