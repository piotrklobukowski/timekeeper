//
//  ToDoListUITests.swift
//  TimekeeperUITests
//
//  Created by Piotr Kłobukowski on 09/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class ToDoListUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launchArguments = ["IS_RUNNING_UITEST"]
        app.launch()
        continueAfterFailure = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddingAndDeletingTasks() {
        
        app.buttons[Controls.Buttons.toDoList].tap()
        
        let toDoListElements = ToDoListElements(app: app, numberOfCells: 4)
        
        XCTAssertEqual(toDoListElements.emptyListTable.cells.count, 0)
        
        toDoListElements.addTask(name: toDoListElements.testTexts[0])
        
        XCTAssertEqual(toDoListElements.table.cells.count, 1)
        XCTAssertEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        
        toDoListElements.addTask(name: toDoListElements.testTexts[1], cancelAction: true)
        
        XCTAssertEqual(toDoListElements.table.cells.count, 1)
        XCTAssertNotEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[1])
        XCTAssertEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        
        toDoListElements.addTask(name: toDoListElements.testTexts[2])
        
        XCTAssertEqual(toDoListElements.table.cells.count, 2)
        XCTAssertEqual(toDoListElements.cells[1].staticTexts.firstMatch.label, toDoListElements.testTexts[2])
        XCTAssertEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        
        toDoListElements.addTask(name: toDoListElements.testTexts[3])
        
        XCTAssertEqual(toDoListElements.table.cells.count, 3)
        XCTAssertEqual(toDoListElements.cells[2].staticTexts.firstMatch.label, toDoListElements.testTexts[3])
        XCTAssertEqual(toDoListElements.cells[1].staticTexts.firstMatch.label, toDoListElements.testTexts[2])
        XCTAssertEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        
        toDoListElements.cells[0].tap()
        app.buttons[Controls.Buttons.finishTask].tap()
        app.buttons[Controls.Buttons.toDoList].tap()
        
        toDoListElements.deleteTask(inCell: 1)
        
        XCTAssertEqual(toDoListElements.table.cells.count, 2)
        XCTAssertEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        XCTAssertEqual(toDoListElements.cells[2].staticTexts.firstMatch.label, toDoListElements.testTexts[3])
        
        toDoListElements.deleteTask(inCell: 2)
        
        XCTAssertEqual(toDoListElements.table.cells.count, 1)
        XCTAssertEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        
        toDoListElements.deleteTask(inCell: 0)
        
        XCTAssertEqual(toDoListElements.table.cells.count, 0)
    }
    
    func testMarkingTasksAsDone() {
        
        XCTAssertFalse(app.buttons[Controls.Buttons.finishTask].isEnabled)
        XCTAssertFalse(app.buttons[Controls.Buttons.start].isEnabled)
        
        let toDoListElements = ToDoListElements(app: app, numberOfCells: 4)
        
        app.buttons[Controls.Buttons.toDoList].tap()
        toDoListElements.addingTasks()
        toDoListElements.cells[2].tap()
        
        XCTAssertTrue(app.buttons[Controls.Buttons.finishTask].isEnabled)
        XCTAssertTrue(app.buttons[Controls.Buttons.start].isEnabled)
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[2])
        
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[3])
        
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        
        app.buttons[Controls.Buttons.toDoList].tap()
        
        XCTAssertEqual(toDoListElements.cells[0].staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[0].exists)
        XCTAssertEqual(toDoListElements.cells[1].staticTexts.firstMatch.label, toDoListElements.testTexts[1])
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[1].exists)
        XCTAssertEqual(toDoListElements.cells[2].staticTexts.firstMatch.label, toDoListElements.testTexts[2])
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[2].label, "checkmark")
        XCTAssertEqual(toDoListElements.cells[3].staticTexts.firstMatch.label, toDoListElements.testTexts[3])
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[3].label, "checkmark")
    }
    
    func testOrderOfMarkingTasksAsDone() {
        let toDoListElements = ToDoListElements(app: app, numberOfCells: 10)
        
        app.buttons[Controls.Buttons.toDoList].tap()
        toDoListElements.addingTasks()
        toDoListElements.cells[7].tap()
        app.buttons[Controls.Buttons.finishTask].tap()
        
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[8])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[9])
        
        app.buttons[Controls.Buttons.toDoList].tap()
        
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[0].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[1].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[2].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[3].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[4].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[5].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[6].exists)
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[7].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[8].label, "checkmark")
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[9].exists)
        
        toDoListElements.cells[4].tap()
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[5])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[6])
        
        app.buttons[Controls.Buttons.toDoList].tap()
        
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[0].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[1].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[2].exists)
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[3].exists)
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[4].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[5].label, "checkmark")
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[6].exists)
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[7].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[8].label, "checkmark")
        XCTAssertFalse(toDoListElements.cellsAccessoryTypes[9].exists)
        
        toDoListElements.cells[2].tap()
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[3])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[6])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[9])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[0])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[1])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, "All your tasks are complete!")

        app.buttons[Controls.Buttons.toDoList].tap()
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[0].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[1].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[2].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[3].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[4].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[5].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[6].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[7].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[8].label, "checkmark")
        XCTAssertEqual(toDoListElements.cellsAccessoryTypes[9].label, "checkmark")
    }
    
    func testOrderOfMakingTasksDoneWhenTasksInTheMiddleWereDeleted() {
        let toDoListElements = ToDoListElements(app: app, numberOfCells: 5)
        
        app.buttons[Controls.Buttons.toDoList].tap()
        toDoListElements.addingTasks()
        toDoListElements.deleteTask(inCell: 2)
        toDoListElements.deleteTask(inCell: 3)
        
        toDoListElements.cells[1].tap()
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[4])
        app.buttons[Controls.Buttons.finishTask].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, toDoListElements.testTexts[0])
    }
    
    func testMainViewUpdateWhenCurrentTaskWasDeleted() {
        let toDoListElements = ToDoListElements(app: app, numberOfCells: 3)
        
        app.buttons[Controls.Buttons.toDoList].tap()
        toDoListElements.addingTasks()
        toDoListElements.cells[1].tap()
        app.buttons[Controls.Buttons.toDoList].tap()
        toDoListElements.deleteTask(inCell: 1)
        app.buttons[Controls.Buttons.back].tap()
        XCTAssertEqual(app.staticTexts.firstMatch.label, "Choose task from To-do list")
    }
    
}
