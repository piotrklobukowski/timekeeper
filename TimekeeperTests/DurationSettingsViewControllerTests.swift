//
//  DurationSettingsViewControllerTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 09/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class DurationSettingsViewControllerTests: XCTestCase {
    
    var coreData: TestCoreData!
    var durationViewController: DurationSettingsViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: String.StoryboardIdentifiers.main.rawValue, bundle: Bundle.main)
        durationViewController = storyboard.instantiateViewController(withIdentifier: String.StoryboardIdentifiers.durationSettingsViewControllerID.rawValue) as! DurationSettingsViewController
        
        coreData = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        durationViewController.settings = Settings(context: coreData.managedObjectContext)
        durationViewController.settings?.loadAllSettings()
        let _ = durationViewController.view
    }
    
    override func tearDown() {
        coreData = nil
        durationViewController = nil
        super.tearDown()
    }
    
    func testShortBreakInitialForPickerView() {
        
        durationViewController.detailsType = .shortBreak
        durationViewController.loadSettingsAndView()
        
        XCTAssertEqual(durationViewController.descriptionLabel.text, "Duration of short break")
        XCTAssertEqual(durationViewController.settingPickerView.selectedRow(inComponent: 0), 0)
        XCTAssertEqual(durationViewController.settingPickerView.selectedRow(inComponent: 2), 5)
    }
    
    func testFocusTimeInitialValueForPickerView() {
        
        durationViewController.detailsType = .focusTime
        durationViewController.loadSettingsAndView()
        
        XCTAssertEqual(durationViewController.descriptionLabel.text, "Duration of focus time")
        XCTAssertEqual(durationViewController.settingPickerView.selectedRow(inComponent: 0), 0)
        XCTAssertEqual(durationViewController.settingPickerView.selectedRow(inComponent: 2), 25)
    }
    
    func testLongBreakInitialValueForPickerView() {
        
        durationViewController.detailsType = .longBreak
        durationViewController.loadSettingsAndView()
        
        XCTAssertEqual(durationViewController.descriptionLabel.text, "Duration of long break")
        XCTAssertEqual(durationViewController.settingPickerView.selectedRow(inComponent: 0), 0)
        XCTAssertEqual(durationViewController.settingPickerView.selectedRow(inComponent: 2), 20)
    }
    
    func testSaveFocusTimeSettings() {
        
        durationViewController.detailsType = .focusTime
        durationViewController.loadSettingsAndView()
        
        durationViewController.settingPickerView.selectRow(10, inComponent: 0, animated: false)
        durationViewController.settingPickerView.selectRow(0, inComponent: 2, animated: false)
        durationViewController.saveButtonPressed(durationViewController.saveButton)
        XCTAssertEqual(durationViewController.settings?.durationSettings[0].amount, 600.0)
    }
    
    func testSaveShortBreakSettings() {
        
        durationViewController.detailsType = .shortBreak
        durationViewController.loadSettingsAndView()
        
        durationViewController.settingPickerView.selectRow(8, inComponent: 0, animated: false)
        durationViewController.settingPickerView.selectRow(20, inComponent: 2, animated: false)
        durationViewController.saveButtonPressed(durationViewController.saveButton)
        XCTAssertEqual(durationViewController.settings?.durationSettings[1].amount, 500.0)
    }
    
    func testSaveLongBreakSettings() {
        
        durationViewController.detailsType = .longBreak
        durationViewController.loadSettingsAndView()
        
        durationViewController.settingPickerView.selectRow(1, inComponent: 0, animated: false)
        durationViewController.settingPickerView.selectRow(0, inComponent: 2, animated: false)
        durationViewController.saveButtonPressed(durationViewController.saveButton)
        XCTAssertEqual(durationViewController.settings?.durationSettings[2].amount, 60.0)
    }
    
    func testSaveMaxFocusTimeSettings() {
        
        durationViewController.detailsType = .focusTime
        durationViewController.loadSettingsAndView()
        
        durationViewController.settingPickerView.selectRow(0, inComponent: 0, animated: false)
        durationViewController.settingPickerView.selectRow(59, inComponent: 2, animated: false)
        durationViewController.saveButtonPressed(durationViewController.saveButton)
        XCTAssertEqual(durationViewController.settings?.durationSettings[0].amount, 59.0)
    }
}
