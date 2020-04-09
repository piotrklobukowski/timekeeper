//
//  ToDoListElements.swift
//  TimekeeperUITests
//
//  Created by Piotr Kłobukowski on 30/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest

class ToDoListElements {
    var testTexts: [String]
    let addButton: XCUIElement
    let textFieldAlert: XCUIElement
    let addTaskAlert: XCUIElement
    let alertAddButton: XCUIElement
    let alertCancelButton: XCUIElement
    let emptyListTable: XCUIElement
    let table: XCUIElement
    var cells = [XCUIElement]()
    var cellsAccessoryTypes = [XCUIElement]()
    
    init(app: XCUIApplication, numberOfCells: Int) {
        self.testTexts = {
           return (0..<numberOfCells).map({ String(format: "test%d", $0)})
        }()
        let toDoListNavigationBar = app.navigationBars[Controls.NavigationBars.yourToDoList]
        self.addButton = toDoListNavigationBar.buttons[Controls.Buttons.add]
        self.addTaskAlert = app.alerts[Controls.Alerts.addTask]
        self.textFieldAlert = self.addTaskAlert.textFields.firstMatch
        self.alertAddButton = self.addTaskAlert.buttons[Controls.Buttons.add]
        self.alertCancelButton = self.addTaskAlert.buttons[Controls.Buttons.cancel]
        self.emptyListTable = app.tables[Controls.Tables.emptyList]
        self.table = app.tables.firstMatch
        self.cells = {
            return (0..<numberOfCells).map({
                table.cells.element(matching: .cell, identifier: "TaskCell_\($0)")
            })
        }()
        self.cellsAccessoryTypes = {
            return (0..<numberOfCells).map({
                table.cells["TaskCell_\($0)"].buttons.firstMatch
            })
        }()
    }
    
    func addTask(name: String, cancelAction: Bool = false) {
        addButton.tap()
        textFieldAlert.tap()
        textFieldAlert.typeText(name)
        if cancelAction {
            alertCancelButton.tap()
        } else {
            alertAddButton.tap()
        }
    }
    
    func addingTasks() {
        testTexts.forEach { addTask(name: $0) }
    }
    
    func deleteTask(inCell number: Int) {
        cells[number].swipeLeft()
        cells[number].buttons[Controls.Buttons.delete].tap()
    }
}

