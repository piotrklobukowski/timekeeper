//
//  SettingsTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 14/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class SettingsTests: XCTestCase {
    
    var settings: Settings!
    var coreData: TestCoreData!
    
    
    override func setUp() {
        super.setUp()
        coreData = TestCoreData(coreDataModelName: String.dataModel)
        settings = Settings(context: coreData.managedObjectContext)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllContainersAreEmpty() {
        XCTAssertTrue(settings.durationSettings.isEmpty)
        XCTAssertTrue(settings.breaksNumberSetting.isEmpty)
        XCTAssertTrue(settings.soundSettings.isEmpty)
        XCTAssertTrue(settings.anotherInformations.isEmpty)
        XCTAssertTrue(settings.clockworkConfigurations.isEmpty)
    }
    
    func testAddDefaultSettings() {
        settings.loadAllSettings()
        
        XCTAssertEqual(settings.breaksNumberSetting.count, 2)
        XCTAssertEqual(settings.durationSettings.count, 3)
        XCTAssertEqual(settings.soundSettings.count, 1)
        XCTAssertEqual(settings.anotherInformations.count, 1)
        XCTAssertEqual(settings.clockworkConfigurations.count, 4)
        
        settings.loadAllSettings()
        
        XCTAssertNotEqual(settings.breaksNumberSetting.count, 4)
        XCTAssertNotEqual(settings.durationSettings.count, 6)
        XCTAssertNotEqual(settings.soundSettings.count, 2)
        XCTAssertNotEqual(settings.anotherInformations.count, 2)
        
        XCTAssertEqual(settings.breaksNumberSetting.count, 2)
        XCTAssertEqual(settings.durationSettings.count, 3)
        XCTAssertEqual(settings.soundSettings.count, 1)
        XCTAssertEqual(settings.anotherInformations.count, 1)
    }
    
    
}
