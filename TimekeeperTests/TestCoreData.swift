//
//  CoreDataUnitTest.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 14/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation
import CoreData
@testable import Timekeeper

class TestCoreData: CoreDataStack {
    override init(coreDataModelName: String) {
        super.init(coreDataModelName: "DataModel")
        self.persistentStoreCoordinator = {
            let psCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            do {
                try psCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            } catch {
                fatalError("Unable to load PersistentStoreCoordinator for Unit Tests")
            }
            
            return psCoordinator
        }()
        
    }
    
}
