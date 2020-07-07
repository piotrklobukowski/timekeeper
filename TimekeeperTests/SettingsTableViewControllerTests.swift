//
//  SettingsTableViewControllerTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 18/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class SettingsTableViewControllerTests: XCTestCase {
    
    var coreData: TestCoreData!
    var settingsTableViewController: SettingsTableViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: String.StoryboardIdentifiers.main.rawValue, bundle: Bundle.main)
        settingsTableViewController = storyboard.instantiateViewController(withIdentifier: String.StoryboardIdentifiers.settingsTableViewControllerID.rawValue) as? SettingsTableViewController
        
        coreData = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        settingsTableViewController.settings = Settings(context: coreData.managedObjectContext)
        let _ = settingsTableViewController.view
    }
    
    override func tearDown() {
        coreData = nil
        settingsTableViewController = nil
        
        super.tearDown()
    }
    
    func testNumberOfSections() {
        let numberOfSections = settingsTableViewController.numberOfSections(in: settingsTableViewController.tableView)
        XCTAssertEqual(numberOfSections, 4)
    }
    
    func testTitleForHeaderInSection() {
        
        var sectionsTitles = [String]()
        
        for section in 0...3 {
            guard let sectionTitle = settingsTableViewController.tableView(settingsTableViewController.tableView, titleForHeaderInSection: section) else { return }
            sectionsTitles.append(sectionTitle)
        }
        
        XCTAssertEqual(sectionsTitles[0], "Duration")
        XCTAssertEqual(sectionsTitles[1], "Number of breaks")
        XCTAssertEqual(sectionsTitles[2], "Sound settings")
        XCTAssertEqual(sectionsTitles[3], "Other")
        
        XCTAssertNotEqual(sectionsTitles[0], "nil")
        XCTAssertNotEqual(sectionsTitles[1], "nil")
        XCTAssertNotEqual(sectionsTitles[2], "nil")
        XCTAssertNotEqual(sectionsTitles[3], "nil")
    }
    
    func testNumberOfRowsInSection() {
        var SectionsRowsCount = [Int]()
        
        for section in 0...3 {
            let numberOfRowsInSection = settingsTableViewController.tableView(settingsTableViewController.tableView, numberOfRowsInSection: section)
            SectionsRowsCount.append(numberOfRowsInSection)
        }
        
        XCTAssertEqual(SectionsRowsCount[0], 3)
        XCTAssertEqual(SectionsRowsCount[1], 1)
        XCTAssertEqual(SectionsRowsCount[2], 1)
        XCTAssertEqual(SectionsRowsCount[3], 1)
    }
    
    func testDetailsForCell() {
        
        let focusTimeCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let shortBreakCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        let longBreakCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 2, section: 0))
        let shortBreaksAmountCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
        let soundCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 2))
        
        XCTAssertEqual(focusTimeCell.textLabel?.text, "Duration of focus time")
        XCTAssertEqual(focusTimeCell.detailTextLabel?.text, "00:25")
        
        XCTAssertEqual(shortBreakCell.textLabel?.text, "Duration of short break")
        XCTAssertEqual(shortBreakCell.detailTextLabel?.text, "00:05")
        
        XCTAssertEqual(longBreakCell.textLabel?.text, "Duration of long break")
        XCTAssertEqual(longBreakCell.detailTextLabel?.text, "00:20")
        
        XCTAssertEqual(shortBreaksAmountCell.textLabel?.text, "Number of short breaks")
        XCTAssertEqual(shortBreaksAmountCell.detailTextLabel?.text, "3")
        
        XCTAssertEqual(soundCell.textLabel?.text, "Sound for alert")
        XCTAssertEqual(soundCell.accessoryType, .disclosureIndicator)
    }
    
    func testDetailsForCellsWhenDataChanged() {
        
        let focusTimeChange = 85.0
        let shortBreakDurationChange = 1825.0
        let longBreakDurationChange = 28.0
        let shortBreaksAmount = 8.0
        
        guard let durationSettings = settingsTableViewController.settings?.durationSettings[0],
            let shortBreakSettings = settingsTableViewController.settings?.durationSettings[1],
            let longBreakSettings = settingsTableViewController.settings?.durationSettings[2],
            let shortBreaksAmountSetitngs = settingsTableViewController.settings?.breaksNumberSettings[0] else { return }
        
        settingsTableViewController.settings?.save(focusTimeChange, for: durationSettings, of: .focusTime)
        settingsTableViewController.settings?.save(shortBreakDurationChange, for: shortBreakSettings, of: .shortBreak)
        settingsTableViewController.settings?.save(longBreakDurationChange, for: longBreakSettings, of: .longBreak)
        settingsTableViewController.settings?.save(shortBreaksAmount, for: shortBreaksAmountSetitngs , of: .shortBreaksNumber)
        
        let focusTimeCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let shortBreakCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        let longBreakCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 2, section: 0))
        let shortBreaksAmountCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
        let soundCell = settingsTableViewController.tableView(settingsTableViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 2))
        
        XCTAssertEqual(focusTimeCell.textLabel?.text, "Duration of focus time")
        XCTAssertEqual(focusTimeCell.detailTextLabel?.text, "01:25")
        
        XCTAssertEqual(shortBreakCell.textLabel?.text, "Duration of short break")
        XCTAssertEqual(shortBreakCell.detailTextLabel?.text, "30:25")
        
        XCTAssertEqual(longBreakCell.textLabel?.text, "Duration of long break")
        XCTAssertEqual(longBreakCell.detailTextLabel?.text, "00:28")
        
        XCTAssertEqual(shortBreaksAmountCell.textLabel?.text, "Number of short breaks")
        XCTAssertEqual(shortBreaksAmountCell.detailTextLabel?.text, "8")
        
        XCTAssertEqual(soundCell.textLabel?.text, "Sound for alert")
        XCTAssertEqual(soundCell.accessoryType, .disclosureIndicator)
    }
    
}
