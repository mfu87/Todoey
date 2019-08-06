//
//  AppDelegate.swift
//  Todoey
//
//  Created by Marcus Fuchs on 06.07.19.
//  Copyright © 2019 Marcus Fuchs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //gets calles when app loads up (before ViewDidLoad!)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        //print out path for userDefaults file
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        return true
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
     
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    //lazy var = only get loaded with value at timepoint when used (memory benefit)
    //NSPersistentContainer = sqlite DB
    
    lazy var persistentContainer: NSPersistentContainer = {
   
        //var that sets up new persistent container with the name of our data model
        let container = NSPersistentContainer(name: "DataModel")
        
        //load up persitent store / log if there are errors
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
         
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //if no errors we return container to set it as the lazy var persistentContainer
        //we can access ist from other classes to save stuff there
        return container
    }()
    
    
    
    // MARK: - Core Data Saving support
    //provides support for saving when app get terminated
    //"context" similar to staging area
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}



