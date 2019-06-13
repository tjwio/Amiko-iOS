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
    private struct Constants {
        static let scheme = "ciaohaus"
        static let user = "user"
        static let id = "id"
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        BITHockeyManager.shared().configure(withIdentifier: BAConstants.HockeyApp.id)
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        BACommonUtility.configureMessages()
        
        if BALocationManager.shared.isAuthorized {
            BALocationManager.shared.initialize()
        }
        
        self.loadInitialViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        BALocationManager.shared.stopUpdatingLocation()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if BAUserHolder.initialized {
            BAUserHolder.shared.reconnect()
        }
        
        if BALocationManager.shared.isAuthorized && !BALocationManager.shared.didReceiveFirstLocation.value {
            BALocationManager.shared.startUpdatingLocation()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme, let host = url.host, scheme.lowercased() == Constants.scheme, host.lowercased() == Constants.user,
            let id = url.paramaters[Constants.id] {
            NotificationCenter.default.post(name: .bumpOpenProfile, object: id)
        }
        
        return true
    }
    
    func loadWelcomeViewController() {
        let navigationController = UINavigationController(rootViewController: BAWelcomeViewController())
        self.window?.rootViewController = navigationController
    }
    
    func loadHomeViewController(user: BAUser, shouldInitialize: Bool = true) {
        if shouldInitialize {
            _ = BAUserHolder.initialize(user: user)
        }
        
        self.window?.rootViewController = BAMainTabBarViewController()
    }
    
    func loadInitialViewController() {
        var viewController: BABaseLoadingViewController
        
        if let userId = BAAuthenticationManager.shared.userId, userId.count > 0 {
            viewController = BAUserLoadingViewController(userId: userId)
        }
        else {
            viewController = BAWelcomeLoadingViewController()
        }
        
        self.window?.rootViewController = viewController
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

