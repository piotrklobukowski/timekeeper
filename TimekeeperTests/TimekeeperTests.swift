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
    
    var toDoList: ToDoList!
    
    private let names = ["Create toDoList code", "Play a game"]
    
    override func setUp() {
        super.setUp()
        toDoList = ToDoList()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        toDoList.deleteTask(position: 1)
        XCTAssertEqual(toDoList.tasks.count, (names.count - 1))
        XCTAssertLessThan(toDoList.tasks.count, names.count)
    }
    
    func testMarkingTaskAsDone() {
        addTasks()
        toDoList.taskIsDone(name: names[0])
        XCTAssertEqual(toDoList.tasks[0].isDone, true)
    }
    
    func testClockworkDefaultValues() {
        let clockwork = Clockwork()
        
        XCTAssertEqual(clockwork.workTime, 25)
        XCTAssertEqual(clockwork.shortBreakTime, 5)
        XCTAssertEqual(clockwork.longBreakTime, 20)
        XCTAssertEqual(clockwork.shortBreaksAmount, 3)
        XCTAssertEqual(clockwork.longBreaksAmount, 1)
        
    }

    private func addTasks() {
        names.forEach {
            toDoList.addTask(name: $0)
        }
    }
    
}
