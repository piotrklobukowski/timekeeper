//
//  BreaksAmountViewControllerTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 12/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class BreaksAmountViewControllerTests: XCTestCase {
    
    var coreData: TestCoreData!
    var amountViewController: BreaksAmountSettingViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: String.StoryboardIdentifiers.main.rawValue, bundle: Bundle.main)
        amountViewController = storyboard.instantiateViewController(withIdentifier: String.StoryboardIdentifiers.breaksAmountSettingsViewControllerID.rawValue) as? BreaksAmountSettingViewController
        
        coreData = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        amountViewController.settings = Settings(context: coreData.managedObjectContext)
        amountViewController.settings?.loadAllSettings()
        amountViewController.detailsType = .shortBreaksNumber
        let _ = amountViewController.view
    }
    
    override func tearDown() {
        coreData = nil
        amountViewController = nil
        super.tearDown()
    }
    
    func testLoadValue() {
        XCTAssertEqual(amountViewController.descriptionLabel.text, "Number of short breaks")
        XCTAssertEqual(amountViewController.settingPickerView.selectedRow(inComponent: 0), 2)
    }
    
    func testSave() {
        amountViewController.settingPickerView.selectRow(8, inComponent: 0, animated: false)
        amountViewController.saveButtonPressed(amountViewController.saveButton)
        XCTAssertEqual(amountViewController.settings?.breaksNumberSettings[0].amount, 9.0)
        
        amountViewController.settingPickerView.selectRow(0, inComponent: 0, animated: false)
        amountViewController.saveButtonPressed(amountViewController.saveButton)
        XCTAssertEqual(amountViewController.settings?.breaksNumberSettings[0].amount, 1.0)
    }
    
}
