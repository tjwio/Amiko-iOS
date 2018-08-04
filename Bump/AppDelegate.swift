//
//  AppDelegate.swift
//  Bump
//
//  Created by Tim Wong on 3/8/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        BITHockeyManager.shared().configure(withIdentifier: BAConstants.HockeyApp.id)
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        BACommonUtility.configureMessages()
        
        self.loadInitialViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        BAUserHolder.shared.reconnect()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func loadWelcomeViewController() {
        let navigationController = UINavigationController(rootViewController: BAWelcomeViewController())
        self.window?.rootViewController = navigationController
    }
    
    private func loadLoadingViewController(userId: String) {
        let navigationController = BAInitialLoadingViewController(userId: userId)
        self.window?.rootViewController = navigationController
    }
    
    func loadHomeViewController(user: BAUser) {
        _ = BAUserHolder.initialize(user: user)
        let navigationController = UINavigationController(rootViewController: BAHomeViewController())
        self.window?.rootViewController = navigationController
    }
    
    func loadInitialViewController() {
        if let userId = BAAuthenticationManager.shared.userId, userId.count > 0 {
            self.loadLoadingViewController(userId: userId)
        }
        else {
            self.loadWelcomeViewController()
        }
    }
    
    //MARK: debug helper font
    private func printFontNames() {
        for familyName in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
}

