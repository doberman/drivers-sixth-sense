//
//  AppDelegate.swift
//  DBRMN Car
//
//  Copyright © 2016 Doberman AB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var backgroundTask: UIBackgroundTaskIdentifier?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let startVC: StartViewController = StartViewController()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = startVC
        self.window!.makeKeyAndVisible()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("ENTER BACKGROUND")
        
        self.backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            if self.backgroundTask != UIBackgroundTaskInvalid {
                UIApplication.sharedApplication().endBackgroundTask(self.backgroundTask!)
                
                self.backgroundTask = UIBackgroundTaskInvalid
            }
        })
        
        
        print("NOTIFICATION")
        //let notification = UILocalNotification()
        //notification.alertBody = "DU KÖR FÖR SNABBT" // text that will be displayed in the notification
        //notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view
        //notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        //notification.activationMode = UIUserNotificationActivationMode.Background
        //notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        //notification.category = "TODO_CATEGORY"
        //application.scheduleLocalNotification(notification)
        
        //UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        
        // Create reminder by setting a local notification
        //let localNotification = UILocalNotification() // Creating an instance of the notification.
        //localNotification.alertTitle = "Notification Title"
        //localNotification.alertBody = "Alert body to provide more details"
        //localNotification.alertAction = "ShowDetails"
        //localNotification.fireDate = NSDate().dateByAddingTimeInterval(10) // 5 minutes(60 sec * 5) from now
        //localNotification.timeZone = NSTimeZone.defaultTimeZone()
        //localNotification.soundName = UILocalNotificationDefaultSoundName // Use the default notification tone/ specify a file in the application bundle
        //localNotification.applicationIconBadgeNumber = 1 // Badge number to set on the application Icon.
        //localNotification.category = "reminderCategory" // Category to use the specified actions
        //UIApplication.sharedApplication().scheduleLocalNotification(localNotification) // Scheduling the notification.
        
        if self.backgroundTask != UIBackgroundTaskInvalid {
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
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

