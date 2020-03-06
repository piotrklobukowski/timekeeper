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
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        settingsTableViewController = storyboard.instantiateViewController(withIdentifier: "SettingsTableViewControllerID") as! SettingsTableViewController
        
        coreData = TestCoreData(coreDataModelName: String.dataModel)
        settingsTableViewController.settings = Settings(context: coreData.managedObjectContext)
        let _ = settingsTableViewController.view        
    }
    
    override func tearDown() {
        
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
        XCTAssertEqual(sectionsTitles[3], "Ohter")
        
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
        XCTAssertEqual(SectionsRowsCount[1], 2)
        XCTAssertEqual(SectionsRowsCount[2], 1)
        XCTAssertEqual(SectionsRowsCount[3], 1)
    }
    
    
}
