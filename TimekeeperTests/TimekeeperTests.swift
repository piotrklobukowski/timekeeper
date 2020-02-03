//
//  TimekeeperTests.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 09/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class TimekeeperTests: XCTestCase {
    
    // WARNING
    // CoreData must be empty, if you want to successfuly complete those tests!
    
    var toDoList: ToDoList!
    
    private let names = ["Play a game" ,"Create toDoList code", "Play a game", "compose symphony", "wash dishes"]
    
    override func setUp() {
        super.setUp()
        toDoList = ToDoList()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        for task in toDoList.tasks {
            toDoList.deleteTask(withID: task.identifier)
        }
        
        toDoList = nil
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
    }
    
    func testMarkingTaskAsDone() {
        addTasks()
        toDoList.taskIsDone(id: toDoList.tasks[0].identifier)
        XCTAssertEqual(toDoList.tasks[0].isDone, true)
    }
    

    private func addTasks() {
        names.forEach {
            toDoList.addTask(description: $0)
        }
    }
    
}
