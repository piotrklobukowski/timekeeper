//
//  AppDelegate.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 09/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreDataStack: CoreDataStack = {
        var coreDataStack: CoreDataStack
        
        if CommandLine.arguments.contains("IS_RUNNING_UITEST") {
            coreDataStack = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        } else {
            coreDataStack = CoreDataStack(coreDataModelName: String.CoreData.dataModel.rawValue)
        }
        return coreDataStack
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if CommandLine.arguments.contains("IS_RUNNING_UITEST") {
            let settings = Settings()
            settings.loadAllSettings()
            settings.save(5.0, for: settings.durationSettings[0], of: .focusTime)
            settings.save(6.0, for: settings.durationSettings[1], of: .shortBreak)
            settings.save(7.0, for: settings.durationSettings[2], of: .longBreak)
            settings.save(2.0, for: settings.breaksNumberSettings[0], of: .shortBreaksNumber)
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
}

