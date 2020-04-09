//
//  MainViewUITests.swift
//  TimekeeperUITests
//
//  Created by Piotr Kłobukowski on 30/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest

class MainViewUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app.launchArguments = ["IS_RUNNING_UITEST"]
        app.launch()
        
        let mainViewElements = MainViewElements(app: app)
        let toDoListElements = ToDoListElements(app: app, numberOfCells: 1)
        mainViewElements.toDoListButton.tap()
        toDoListElements.addingTasks()
        toDoListElements.cells[0].tap()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPauseButtonStopsPomodoroClockwork() {
        let mainViewElements = MainViewElements(app: app)
        let exp = expectation(description: "2 seconds passed")
        let expPause = expectation(description: "2 seconds after pause passed")
        
        mainViewElements.clockOnButton.tap()
        XCTAssertEqual(mainViewElements.clockOnButton.label, "Pause")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
        mainViewElements.clockOnButton.tap()
        
        XCTAssertEqual(mainViewElements.clockOnButton.label, "Continue")
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:03")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 0/2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expPause.fulfill()
        }
        wait(for: [expPause], timeout: 2)
        
        XCTAssertEqual(mainViewElements.clockOnButton.label, "Continue")
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:03")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 0/2")
    }
    
    func testPauseButtonStopsAndResumeClockwork() {
        let mainViewElements = MainViewElements(app: app)
        let exp = expectation(description: "1 seconds passed")
        let expPause = expectation(description: "2 seconds of pause")
        let expResume = expectation(description: "2 seconds after pause passed")
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        mainViewElements.clockOnButton.tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expPause.fulfill()
        }
        wait(for: [expPause], timeout: 2)
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expResume.fulfill()
        }
        wait(for: [expResume], timeout: 2)
        
        XCTAssertEqual(mainViewElements.clockOnButton.label, "Pause")
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:02")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 0/2")
    }
    
    func testPomodoroClockworkSwithToShortBreakAfterGivenTime() {
        let mainViewElements = MainViewElements(app: app)
        let exp = expectation(description: "One focus period passed")
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:06")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Break")
    }
    
    func testPomodoroClockworkSwitchToFocusPhaseAfterShortBreak() {
        let mainViewElements = MainViewElements(app: app)
        let exp = expectation(description: "One focus period and one short break passed")
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 11)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:05")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 1/2")
    }
    
    func testPomodoroClockworkSwitchToLongBreakAfterGivenAmountOfShortBreaks() {
        let mainViewElements = MainViewElements(app: app)
        let exp = expectation(description: "Three focus periods and two short breaks passed")
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 27) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 27)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:07")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Long Break")
    }
    
    func testPomodoroClockworkSwitchToWorkTimeAfterLongBreak() {
        let mainViewElements = MainViewElements(app: app)
        let exp = expectation(description: "Three focus periods, two short breaks and one long break passed")
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 34) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 34)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:05")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 0/2")
    }
    
    func testPomodoroCLockworkSwitchToShortBreakAfterOneLongBreakAndWorkTime() {
        let mainViewElements = MainViewElements(app: app)
        let exp = expectation(description: "Four focus periods, two short breaks, one long break passed")
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 39) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 39)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:06")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Break")
    }
    
    func testPomodoroClockworkWorksInAllPhases() {
        let mainViewElements = MainViewElements(app: app)
        let exp1FocusTime = expectation(description: "First focus time passed")
        let exp1shortBreak = expectation(description: "First short break passed")
        let exp2FocusTime = expectation(description: "Second focus time passed")
        let exp2shortBreak = expectation(description: "Second short break passed")
        let exp3FocusTime = expectation(description: "Third focus time passed")
        let expLongBreak = expectation(description: "Long break passed")
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            exp1FocusTime.fulfill()
        }
        wait(for: [exp1FocusTime], timeout: 5)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:06")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Break")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            exp1shortBreak.fulfill()
        }
        wait(for: [exp1shortBreak], timeout: 6)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:05")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 1/2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            exp2FocusTime.fulfill()
        }
        wait(for: [exp2FocusTime], timeout: 5)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:06")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Break")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            exp2shortBreak.fulfill()
        }
        wait(for: [exp2shortBreak], timeout: 6)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:05")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 2/2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            exp3FocusTime.fulfill()
        }
        wait(for: [exp3FocusTime], timeout: 5)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:07")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Long Break")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            expLongBreak.fulfill()
        }
        wait(for: [expLongBreak], timeout: 7)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:05")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 0/2")
    }
}
