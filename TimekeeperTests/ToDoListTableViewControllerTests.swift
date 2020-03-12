//
//  ToDoListTableViewControllerTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 17/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import XCTest
@testable import Timekeeper

class ToDoListTableViewControllerTests: XCTestCase {
    
    var coreData: TestCoreData!
    var tableViewController: ToDoListTableViewController!
    
    private let names = ["Play a game", "Create toDoList code", "Play a game", "compose symphony", "wash dishes", "make dinner", "Create CoreData code"]
    private let positions = [1,2,4,6]

    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: String.StoryboardIdentifiers.main.rawValue, bundle: Bundle.main)
        tableViewController = storyboard.instantiateViewController(withIdentifier: String.StoryboardIdentifiers.toDoListTableViewControllerID.rawValue) as! ToDoListTableViewController
        
        coreData = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        tableViewController.toDoList = ToDoList(context: coreData.managedObjectContext)
        let _ = tableViewController.view
        
    }
    
    override func tearDown() {
        guard let tasksIsEmpty = tableViewController.toDoList?.tasks.isEmpty else { return }
        if !tasksIsEmpty {
            guard let tasks = tableViewController.toDoList?.tasks else { return }
            for task in tasks {
                tableViewController.toDoList?.deleteTask(withID: task.identifier)
            }
        }
        super.tearDown()
    }
    
    func testTableHasNoCells() {
        let numberOfRows = tableViewController.tableView(tableViewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 0)
        XCTAssertEqual(numberOfRows, tableViewController.toDoList?.tasks.count)
        XCTAssertNil(tableViewController.tableView.cellForRow(at: IndexPath(row: 3, section: 0)))
        
    }
    
    func testNumberOfRows() {
        addTasks()
        let numberOfRows = tableViewController.tableView(tableViewController.tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(tableViewController.toDoList?.tasks.count, names.count)
        XCTAssertEqual(numberOfRows, names.count)
        XCTAssertEqual(numberOfRows, tableViewController.toDoList?.tasks.count)
    }
    
    func testInformationsMatchingWithCells() {
        
        addTasks()
        
        var cells = [UITableViewCell]()
        
        for row in names.startIndex ..< names.endIndex {
            let cell = tableViewController.tableView(tableViewController.tableView, cellForRowAt: IndexPath(row: row, section: 0))
            cells.append(cell)
        }
        
        XCTAssertEqual(cells[0].textLabel?.text, names[0])
        XCTAssertTrue(cells[0].accessoryType == .none)
        
        XCTAssertEqual(cells[1].textLabel?.text, names[1])
        XCTAssertTrue(cells[1].accessoryType == .checkmark)
        
        XCTAssertEqual(cells[2].textLabel?.text, names[2])
        XCTAssertTrue(cells[2].accessoryType == .checkmark)
        
        XCTAssertEqual(cells[3].textLabel?.text, names[3])
        XCTAssertTrue(cells[3].accessoryType == .none)
        
        XCTAssertEqual(cells[4].textLabel?.text, names[4])
        XCTAssertTrue(cells[4].accessoryType == .checkmark)
        
        XCTAssertEqual(cells[5].textLabel?.text, names[5])
        XCTAssertTrue(cells[5].accessoryType == .none)
        
        XCTAssertEqual(cells[6].textLabel?.text, names[6])
        XCTAssertTrue(cells[6].accessoryType == .checkmark)
    }
    
    func testRemoveCellsFromTableView() {
        addTasks()
        
        tableViewController.tableView(tableViewController.tableView, commit: .delete, forRowAt: IndexPath(row: 5, section: 0))
        
        XCTAssertNotEqual(tableViewController.toDoList?.tasks[5].descriptionOfTask, "make dinner")
        
        tableViewController.tableView(tableViewController.tableView, commit: .delete, forRowAt: IndexPath(row: 5, section: 0))
        
        XCTAssertNil(tableViewController.tableView.cellForRow(at: IndexPath(row: 5, section: 0)))
        
    }
    
    
    private func addTasks() {
        names.forEach {
            tableViewController.toDoList?.addTask(description: $0)
        }
        positions.forEach {
            guard let id = tableViewController.toDoList?.tasks[$0].identifier else { return }
            tableViewController.toDoList?.taskIsDone(id: id)
        }
        
    }
    
}
