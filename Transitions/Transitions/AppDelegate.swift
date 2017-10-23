//
//  AppDelegate.swift
//  Transitions
//
//  Created by Boyan Yankov on 13/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configure_3rdParties()
        self.configureApplicationAppearance()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - UI Configurations
fileprivate extension AppDelegate {
    
    func configureApplicationAppearance() {
        UINavigationBar.appearance().barStyle = .blackTranslucent
        UINavigationBar.appearance().tintColor = UIColor.lightText
        UIBarButtonItem.appearance().tintColor = UIColor.lightText
        UIButton.appearance().tintColor = UIColor.lightText
    }
}

// MARK: - 3rd parties configurations

fileprivate extension AppDelegate {
    
    func configure_3rdParties() {
        self.configure_simpleLogger()
    }
    
    func configure_simpleLogger() {
        #if DEBUG
            Logger.enableLogging(true)
        #endif
    }
}

