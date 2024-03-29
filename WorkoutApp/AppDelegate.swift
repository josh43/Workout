//
//  AppDelegate.swift
//  WorkoutApp
//
//  Created by joshua on 2/7/17.
//  Copyright (c) 2017 joshua. All rights reserved.
//

import UIKit
import Alamofire.Swift
import SwiftyJSON.Swift




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func insertDummyWorkouts(){
        
        func getJSONFrom(_ str : String) -> Data?{
            
            if let path = Bundle.main.path(forResource: str, ofType: "formatted") {
                
                
                return FileManager.default.contents(atPath: path)
            }else{
                return nil
            }
        }
        
        
        let jsonString = JSON(getJSONFrom("curl1"))
        var map: WorkoutMap! = nil
        map = WorkoutMap.Singleton
        map.deleteAll()
        map.reloadMapList()
        var workout: Workout! = nil
        if (workout = Workout(fromJson: jsonString)) != nil{
            map.addWorkout("12304", workout)
            
            
        }
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        WorkoutMap.Singleton.loadAll("real")
//        insertDummyWorkouts()
        
        //        // Override point for customization after application launch.
        //        let splitViewController = self.window!.rootViewController as! UISplitViewController
        //        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        //        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        //        splitViewController.delegate = self
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        WorkoutMap.Singleton.saveAll("real")
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
        WorkoutMap.Singleton.saveAll("real")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Split view
    
    
    
    
}
