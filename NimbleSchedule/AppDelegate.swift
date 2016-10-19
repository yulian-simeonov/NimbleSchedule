    //
//  AppDelegate.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/8/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit
import CoreLocation
import Parse
    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        let lang = SharedDataManager.sharedInstance.langCode == ELangCode.English ? "en" : "fr"
        
        LocalizeHelper.sharedInstance.lang = lang

        if application.respondsToSelector("registerUserNotificationSettings:") {
            if #available(iOS 8.0, *) {
                let types:UIUserNotificationType = ([.Alert, .Sound, .Badge])
                let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            } else {
                application.registerForRemoteNotificationTypes([.Alert, .Sound, .Badge])
            }
        }
        else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes([.Alert, .Sound, .Badge])
        }
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId(parse_app_id, clientKey: parse_client_key)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
       
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if  !CLLocationManager.locationServicesEnabled() ||
            CLLocationManager.authorizationStatus() == .NotDetermined {
                SharedDataManager.sharedInstance.locationManager.requestWhenInUseAuthorization()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let installation = PFInstallation.currentInstallation()
    installation.setDeviceTokenFromData(deviceToken)
    installation.channels = ["global","Test"]
    installation.saveInBackground()
        
        let pushQuery = PFInstallation.query()
        pushQuery?.whereKey("Test", equalTo: true)
        
        let push = PFPush.init()
        push.setQuery(pushQuery)
        push.setMessage("Test")
        push.sendPushInBackground()
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }        
        
        print("tokenString: \(tokenString)")
}
 
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    PFPush.handlePush(userInfo)
}

}

