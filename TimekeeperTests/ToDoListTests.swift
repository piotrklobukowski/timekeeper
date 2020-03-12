//
//  ToDoListTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 13/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class ToDoListTests: XCTestCase {
    
    var toDoList: ToDoList!
    var coreData: TestCoreData!
    
    private let names = ["Play a game" ,"Create toDoList code", "Play a game", "compose symphony", "wash dishes"]
    
    override func setUp() {
        super.setUp()
        coreData = TestCoreData(coreDataModelName: String.CoreData.dataModel.rawValue)
        toDoList = ToDoList(context: coreData.managedObjectContext)
    }
    
    override func tearDown() {
        toDoList = nil
        coreData = nil
        super.tearDown()
    }
    
    func testToDoListIsEmpty() {
        XCTAssertEqual(toDoList.tasks.count, 0)
    }
    
    func testToDoListTaskCountAfterAddingNewTasks() {
        addTasks()
        XCTAssertEqual(toDoList.tasks.count, names.count)
    }
    
    func testToDoListTaskRemoval() {
        addTasks()
        toDoList.deleteTask(withID: toDoList.tasks[0].identifier)
        XCTAssertEqual(toDoList.tasks.count, (names.count - 1))
        XCTAssertFalse(toDoList.tasks[0].descriptionOfTask == "Play a game")
        XCTAssertEqual(toDoList.tasks[0].descriptionOfTask, "Create toDoList code")
    }
    
    func testMarkingTaskAsDone() {
        addTasks()
        toDoList.taskIsDone(id: toDoList.tasks[0].identifier)
        XCTAssertEqual(toDoList.tasks[0].isDone, true)
    }
    
    func testSaveAndLoadTasks() {
        addTasks()
        toDoList = nil
        toDoList = ToDoList(context: coreData.managedObjectContext)
        toDoList.loadToDoList()
        
        XCTAssertEqual(toDoList.tasks.count, names.count)
        XCTAssertEqual(toDoList.tasks[0].descriptionOfTask, names[0])
        XCTAssertEqual(toDoList.tasks[2].descriptionOfTask, names[2])
        XCTAssertEqual(toDoList.tasks[4].descriptionOfTask, names[4])
    }
    
    private func addTasks() {
        names.forEach {
            toDoList.addTask(description: $0)
        }
    }
    
}
