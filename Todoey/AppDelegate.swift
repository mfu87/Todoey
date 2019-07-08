//
//  AppDelegate.swift
//  Todoey
//
//  Created by Marcus Fuchs on 06.07.19.
//  Copyright © 2019 Marcus Fuchs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //gets calles when app loads up (before ViewDidLoad!)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        //print out path for userDefaults file
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }

    //gets called when sth. happens to the phone when app open (receives a call etc...)
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    
    //when homebutton pressed / other app opened
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    //when app is terminated (can be user or system triggered)
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }


}

