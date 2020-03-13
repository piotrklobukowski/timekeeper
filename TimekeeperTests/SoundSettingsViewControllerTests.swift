//
//  SoundSettingsViewControllerTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 12/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class SoundSettingsViewControllerTests: XCTestCase {
    
    var coreData: TestCoreData!
    var soundViewController: SoundSettingViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: String.StoryboardIdentifiers.main.rawValue, bundle: Bundle.main)
        soundViewController = storyboard.instantiateViewController(withIdentifier: String.StoryboardIdentifiers.soundSettingsViewControllerID.rawValue) as! SoundSettingViewController
        
        coreData = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        soundViewController.settings = Settings(context: coreData.managedObjectContext)
        soundViewController.settings?.loadAllSettings()
        soundViewController.detailsType = .alertSound
        let _ = soundViewController.view
    }
    
    override func tearDown() {
        coreData = nil
        soundViewController = nil
        super.tearDown()
    }
    
    func testLoadDataInController() {
        let soundIndex = soundViewController.settingPickerView.selectedRow(inComponent: 0)
        let soundRow = soundViewController.settingPickerView.view(forRow: soundIndex, forComponent: 0) as! UILabel
        XCTAssertEqual(soundViewController.descriptionLabel.text, "Sound for alert")
        XCTAssertEqual(soundRow.text, "Bell Sound Ring")
    }
    
    func testSaveDataAndLoadController() {
        soundViewController.settingPickerView.selectRow(2, inComponent: 0, animated: false)
        soundViewController.saveButtonPressed(soundViewController.saveButton)
        XCTAssertEqual(soundViewController.settings?.soundSettings[0].settingString, "Japanese_Temple_Bell_Small")
        
        soundViewController.loadSettingsAndView()
        let soundIndex = soundViewController.settingPickerView.selectedRow(inComponent: 0)
        let soundRow = soundViewController.settingPickerView.view(forRow: soundIndex, forComponent: 0) as! UILabel
        XCTAssertEqual(soundViewController.descriptionLabel.text, "Sound for alert")
        XCTAssertEqual(soundRow.text, "Japanese Temple Bell Small")
        
    }
    
}
