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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testToDoListisEmpty() {
        let toDoList = ToDoList()
        
        XCTAssertEqual(toDoList.tasks.count, 0)
    }
    
    func testClockworkDefaultValues() {
        let clockwork = Clockwork()
        
        XCTAssertEqual(clockwork.workTime, 25)
        XCTAssertEqual(clockwork.shortBreakTime, 5)
        XCTAssertEqual(clockwork.longBreakTime, 20)
        XCTAssertEqual(clockwork.shortBreaksAmount, 3)
        XCTAssertEqual(clockwork.longBreaksAmount, 1)
        
    }
    
    
}
