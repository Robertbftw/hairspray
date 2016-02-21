//
//  AppDelegate.swift
//  Hairspray
//
//  Created by Robert Boerema on 2/14/16.
//  Copyright © 2016 Robert Boerema. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        let notificationTypes : UIUserNotificationType = [.Alert, .Badge, .Sound]
        let notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //Load storyboards
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        let screenHeight: NSNumber = bounds.size.height
        
        if screenHeight == 480 {
            NSUserDefaults.standardUserDefaults().setObject("iPhone4", forKey: "deviceFamily")
            NSUserDefaults.standardUserDefaults().setInteger(4, forKey: "deviceCode")
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "iPhone4", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("home") as UIViewController
            self.window!.rootViewController = viewcontroller
        }
        else if screenHeight == 568 {
             NSUserDefaults.standardUserDefaults().setObject("iPhone5", forKey: "deviceFamily")
            NSUserDefaults.standardUserDefaults().setInteger(5, forKey: "deviceCode")
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "iPhone5", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("home") as UIViewController
            self.window!.rootViewController = viewcontroller
        }
        else if screenHeight == 667 {
             NSUserDefaults.standardUserDefaults().setObject("iPhone6", forKey: "deviceFamily")
            NSUserDefaults.standardUserDefaults().setInteger(6, forKey: "deviceCode")
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "iPhone6", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("home") as UIViewController
            self.window!.rootViewController = viewcontroller
        }
        else if screenHeight == 736 {
             NSUserDefaults.standardUserDefaults().setObject("iPhone6P", forKey: "deviceFamily")
            NSUserDefaults.standardUserDefaults().setInteger(7, forKey: "deviceCode")
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "iPhone6P", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("home") as UIViewController
            self.window!.rootViewController = viewcontroller
        }
        else {
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "iPhone4", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("home") as UIViewController
            self.window!.rootViewController = viewcontroller
        }

        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = false
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        NSUserDefaults.standardUserDefaults().setObject(deviceTokenString, forKey: "deviceToken")
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

