//
//  AppDelegate.swift
//  Spotlight_PDP
//
//  Created by Aynur Galiev on 14.06.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        return true
    }

    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        if userActivity.activityType == CSSearchableItemActionType {
            if let navController = self.window?.rootViewController as? UINavigationController,
               let topViewController = navController.topViewController as? ProductsViewController {
                restorationHandler([topViewController])
            }
            return true
        }
        return false
    }

}

