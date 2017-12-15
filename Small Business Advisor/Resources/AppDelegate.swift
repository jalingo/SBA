//
//  AppDelegate.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/24/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud
//import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MCNotificationConverter {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        
        // This block checks to see that User is logged in to their iCloud Account.
        CKContainer.default().accountStatus { status, possibleError in
            if let error = possibleError as? CKError {
                print("E!!: error @ credential check")
                print("#\(error.errorCode) :: \(error.localizedDescription)")
            }
            
            var msg: String?
print("## status: \(status) \(status.rawValue)")
            switch status {
    /* 0 */ case .couldNotDetermine: msg = "This app requires internet access to work properly."
    /* 1 */ case .available: break      // msg will remain nil, no message will be posted.
    /* 2 */ case .restricted: msg = "This app requires internet access and an iCloud account to work properly. Access was denied due to Parental Controls or Mobile Device Management restrictions."
    /* 3 */ case .noAccount: msg = "This app requires internet access and an iCloud account to work properly. From Settings, tap iCloud, authenticate your Apple ID and enable iCloud drive. If you don't have an account, tap Create a new Apple ID."
            }
            
            if let message = msg {
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                let settings = UIAlertAction(title: "Settings", style: .default) { alert in
                    
                    // This will take the user to settings app if they hit 'Settings'.
                    if let goToSettingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                        DispatchQueue(label: "App Switcher").async { UIApplication.shared.open(goToSettingsURL, options: [:], completionHandler: nil) }
                    }
                }
                
                alertController.addAction(settings)
                
                DispatchQueue.main.async {
                    application.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        convertToLocal(from: userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
print("** registered with token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
print("!! Error @ UIApp.didFailToRegister")
print("\(error.localizedDescription)")
        
        // TODO !! graceful disable &or error handling...
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

