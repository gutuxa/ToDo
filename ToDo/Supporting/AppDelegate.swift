//
//  AppDelegate.swift
//  ToDo
//
//  Created by Oksana Tugusheva on 11.05.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        window?.rootViewController = UINavigationController(rootViewController: TaskListTableViewController())
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        TaskData.shared.saveContext()
    }
}

