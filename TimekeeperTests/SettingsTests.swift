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
        coreData = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        settings = Settings(context: coreData.managedObjectContext)
    }
    
    override func tearDown() {
        settings = nil
        coreData = nil
        super.tearDown()
    }
    
    func testAllContainersAreEmpty() {
        XCTAssertTrue(settings.durationSettings.isEmpty)
        XCTAssertTrue(settings.breaksNumberSettings.isEmpty)
        XCTAssertTrue(settings.soundSettings.isEmpty)
        XCTAssertTrue(settings.anotherInformations.isEmpty)
        XCTAssertTrue(settings.clockworkConfigurations.isEmpty)
    }
    
    func testAddDefaultSettings() {
        settings.loadAllSettings()
        
        XCTAssertEqual(settings.breaksNumberSettings.count, 1)
        XCTAssertEqual(settings.durationSettings.count, 3)
        XCTAssertEqual(settings.soundSettings.count, 1)
        XCTAssertEqual(settings.anotherInformations.count, 1)
        XCTAssertEqual(settings.clockworkConfigurations.count, 4)
        
        settings.loadAllSettings()
        
        XCTAssertNotEqual(settings.breaksNumberSettings.count, 4)
        XCTAssertNotEqual(settings.durationSettings.count, 6)
        XCTAssertNotEqual(settings.soundSettings.count, 2)
        XCTAssertNotEqual(settings.anotherInformations.count, 2)
        
        XCTAssertEqual(settings.breaksNumberSettings.count, 1)
        XCTAssertEqual(settings.durationSettings.count, 3)
        XCTAssertEqual(settings.soundSettings.count, 1)
        XCTAssertEqual(settings.anotherInformations.count, 1)
    }
    
    func testLoadSpecificSettings() {
        settings.loadAllSettings()
        settings = nil
        settings = Settings(context: coreData.managedObjectContext)
        
        var specificSettings = try! settings.loadSpecificSetting(for: SettingsDetailsType.focusTime)
        let focusTime = specificSettings.first
        
        XCTAssertNotNil(focusTime)
        XCTAssertEqual(focusTime?.amount, 25.0)
        XCTAssertEqual(focusTime?.descriptionOfSetting, "Duration of focus time")
        XCTAssertNil(focusTime?.settingString)

        specificSettings = try! settings.loadSpecificSetting(for: SettingsDetailsType.shortBreak)
        let shortBreak = specificSettings.first
        
        XCTAssertNotNil(shortBreak)
        XCTAssertEqual(shortBreak?.amount, 5.0)
        XCTAssertEqual(shortBreak?.descriptionOfSetting, "Duration of short break")
        XCTAssertNil(shortBreak?.settingString)
        
        specificSettings = try! settings.loadSpecificSetting(for: SettingsDetailsType.longBreak)
        let longBreak = specificSettings.first
        
        XCTAssertNotNil(longBreak)
        XCTAssertEqual(longBreak?.amount, 20.0)
        XCTAssertEqual(longBreak?.descriptionOfSetting, "Duration of long break")
        XCTAssertNil(longBreak?.settingString)
        
        specificSettings = try! settings.loadSpecificSetting(for: SettingsDetailsType.shortBreaksNumber)
        let shortBreaksNumber = specificSettings.first
        
        XCTAssertNotNil(shortBreaksNumber)
        XCTAssertEqual(shortBreaksNumber?.amount, 3.0)
        XCTAssertEqual(shortBreaksNumber?.descriptionOfSetting, "Number of short breaks")
        XCTAssertNil(shortBreaksNumber?.settingString)
        
        specificSettings = try! settings.loadSpecificSetting(for: SettingsDetailsType.alertSound)
        let alertSetting = specificSettings.first
        
        XCTAssertNotNil(alertSetting)
        XCTAssertEqual(alertSetting?.amount, 0.0)
        XCTAssertEqual(alertSetting?.descriptionOfSetting, "Sound for alert")
        XCTAssertEqual(alertSetting?.settingString, "Bell Sound Ring")
    }
    
    func testSave() {
        settings.loadAllSettings()
        settings = nil
        settings = Settings(context: coreData.managedObjectContext)
        settings.loadAllSettings()
        
        let focusTimeChange = 30.0
        let shortBreakDurationChange = 10.0
        let longBreakDurationChange = 28.0
        let shortBreaksAmount = 8.0
        let soundTitleChange = "Japanese_Temple_Bell_Small"
        
        settings.save(focusTimeChange, for: settings.durationSettings[0], of: .focusTime)
        settings.save(shortBreakDurationChange, for: settings.durationSettings[1], of: .shortBreak)
        settings.save(longBreakDurationChange, for: settings.durationSettings[2], of: .longBreak)
        settings.save(shortBreaksAmount, for: settings.breaksNumberSettings[0], of: .shortBreaksNumber)
        settings.save(soundTitleChange, for: settings.soundSettings[0], of: .alertSound)
        
        settings = nil
        settings = Settings(context: coreData.managedObjectContext)
        settings.loadAllSettings()
        
        XCTAssertEqual(settings.durationSettings[0].amount, focusTimeChange)
        XCTAssertEqual(settings.durationSettings[1].amount, shortBreakDurationChange)
        XCTAssertEqual(settings.durationSettings[2].amount, longBreakDurationChange)
        XCTAssertEqual(settings.breaksNumberSettings[0].amount, shortBreaksAmount)
        XCTAssertEqual(settings.soundSettings[0].settingString, soundTitleChange)
    }
    
}
