//
//  AppDelegate.swift
//  BillBoard
//
//  Created by Karthik Challa on 01/03/16.
//  Copyright © 2016 MacBook Pro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var notificationBody:String?
    
    var colorflag = 0;
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Kii.beginWithID("2ffeb59c", andKey: "4a1ea3db6e13e83b6c3e54b48374f42c", andSite: KiiSite.US)
        
        Kii.beginWithID("bcff6091", andKey: "ab38ffb19a919aa4bbe823d6d05dc653", andSite: KiiSite.US)
        
        // Register APNS
        if #available(iOS 8, *) {
            // iOS8
            // define notification actions (In case of categorized remote push notifications)
            let acceptAction = UIMutableUserNotificationAction()
            acceptAction.identifier = "ACCEPT_IDENTIFIER"
            acceptAction.title = "Accept"
            acceptAction.destructive = false
            
            let declineAction = UIMutableUserNotificationAction()
            declineAction.identifier = "DECLINE_IDENTIFIER"
            declineAction.title = "Decline"
            // will appear as red
            declineAction.destructive = true
            // tapping this actions will not launch the app but only trigger background task
            declineAction.activationMode = UIUserNotificationActivationMode.Background
            // this action will be executed without necessity of pass code authentication (if locked)
            declineAction.authenticationRequired = false;
            
            // Define Categories (In case of categorized remote push notifications)
            let inviteCategory = UIMutableUserNotificationCategory()
            inviteCategory.identifier = "MESSAGE_CATEGORY"
            inviteCategory.setActions([acceptAction,declineAction], forContext: UIUserNotificationActionContext.Default)
            inviteCategory.setActions([acceptAction,declineAction], forContext: UIUserNotificationActionContext.Minimal)
            let categories : Set<UIUserNotificationCategory>= [inviteCategory]
            
            // register notifications
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories)
            application.registerUserNotificationSettings(notificationSettings)
            application.registerForRemoteNotifications()
        }
        else {
            // iOS7 or earlier
            application.registerForRemoteNotificationTypes([.Alert, .Badge, .Sound])
        }
        
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Install with APNS development mode : ON
        // make sure to change the value of developmentMode to false whenever make a release build (adhoc/ release to app store).
        do{
            try KiiUser.authenticateSynchronous("ltsTest@kii.com", withPassword: "test1234")
            
            try KiiPushInstallation.installSynchronousWithDeviceToken(deviceToken, andDevelopmentMode: true)
            print("token: \(deviceToken)")
            
            
        }catch let error as NSError {
            // Error handling
            print("Error: \(error)")
            return
        }
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Error : Fail to register to APNS : \(error)")
    }
    /*func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("Received notification : \(userInfo)")
        
        // Create KiiPushMessage from userInfo.
        let message = KiiPushMessage(fromAPNS: userInfo)
        // Get Topic string using getValueOfKiiMessageField. "KiiMessage_TOPIC" is enum that is defined in KiiMessageField.
        //let title = message.getValueOfKiiMessageField(.TOPIC)
        // Show alert message
        //message.showMessageAlertWithTitle(title)
        
        notificationBody = message.getAlertBody()
        print("Notification body:\(notificationBody)")
        
        NSUserDefaults.standardUserDefaults().setObject(notificationBody, forKey: "notificationBody")
        
        //let state: UIApplicationState = UIApplication.sharedApplication().applicationState
       
        
            print("active********")
            //Do checking here.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("billBoard") as! BillBoardViewController
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        
    }*/
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let message = KiiPushMessage(fromAPNS: userInfo)
        notificationBody = message.getAlertBody()
        
        if application.applicationState == .Inactive {
            NSLog("Inactive")
            //Show the view with the content of the push
            completionHandler(.NewData)
        }
        else if application.applicationState == .Background {
            NSLog("Background")
            //Refresh the local model
            completionHandler(.NewData)
        }
        else {
            NSLog("Active")
            //Show an in-app banner
            completionHandler(.NewData)
        }
        
        if colorflag == 0 {
            colorflag = 1
        } else if colorflag == 1 {
            colorflag = 2
        } else if colorflag == 2 {
            colorflag = 3
        } else if colorflag == 3 {
            colorflag = 0
        } 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("billBoard") as! BillBoardViewController
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
    }
}

