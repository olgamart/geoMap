//
//  AppDelegate.swift
//  geoMap
//
//  Created by Olga Martyanova on 16/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var safetyWindow: UIWindow?
    var window: UIWindow?
    var controller: UIViewController?
    var safetyController: UIViewController?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyB7r97vjsGlvyy3oRM8cIMGV0JogZMJ5yY")
      
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(LoginViewController.self)
        window = UIWindow()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            guard granted else {
                print ("разрешение не получено")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
           }
        }
        
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        safetyController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(SafetyViewController.self)
        safetyWindow = UIWindow()
        safetyWindow?.rootViewController = safetyController
        if let win = window {
            safetyWindow?.windowLevel = win.windowLevel + 1
        }
        safetyWindow?.isHidden = false        

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            guard granted else {
                print ("разрешение не получено")
                return
            }
            
            let schedulerNotification = SchedulerNotification()
            let contentNotification = schedulerNotification.makeNotificatioContent(title: "Новое сообщение",
                                                                                   subtitle: "локальное",
                                                                                   body: "Откройте приложение geoMap")
            let triggerNotification = schedulerNotification.makeIntervalNotificationTrigger(timeIntervalsecons: 5)
            schedulerNotification.sendNotificationRequest(content: contentNotification,
                                                          trigger: triggerNotification,
                                                          identifier: "openApp")
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
     
        if safetyWindow != nil {
           safetyWindow?.isHidden = true
           safetyWindow = nil
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Токен: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        print(error)
    }
}

