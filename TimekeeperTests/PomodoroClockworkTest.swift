//
//  ClockworkTest.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 26/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class PomodoroClockworkTest: XCTestCase {
    
    var sut: PomodoroClockwork!
    
    override func setUp() {
        super.setUp()
        sut = PomodoroClockwork(
            settings: ClockSettings(
                workTimeDuration: 1,
                shortBreakDuration: 1,
                longBreakDuration: 2,
                shortBreaksCount: 2)
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testPauseMethodWorksProperrly() {
        let exp = expectation(description: "It's 1 second later")
        sut.start()
        sut.pause()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(sut.currentPhase, PomodoroPhases.work)
    }
    
    func testResumeMethodWorksProperrly() {
        let exp = expectation(description: "It's 1 second later")
        sut.start()
        sut.pause()
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(sut.currentPhase, PomodoroPhases.shortBreak)
    }
    
    func testSwitchToShortBreakAfterGivenTime() {
        let exp = expectation(description: "It's 1 second later")
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(sut.currentPhase, PomodoroPhases.shortBreak)
        XCTAssertEqual(sut.currentPhaseTime, "0:00")
    }
    
    func testSwitchToWorkTimeAfterShortBreak() {
        let exp = expectation(description: "It's 2 seconds later.")
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 3)
        XCTAssertEqual(sut.currentPhase, PomodoroPhases.work)
        XCTAssertEqual(sut.currentPhaseTime, "0:00")
    }
    
    func testSwitchToLongBreakAfterGivenNumberOfShortBreaks() {
        let exp = expectation(description: "It's 5 seconds later.")
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 6)
        XCTAssertEqual(sut.currentPhase, PomodoroPhases.longBreak)
        XCTAssertEqual(sut.currentPhaseTime, "0:00")
    }
    
    func testSwitchToWorkTimeAfterLongBreak() {
        let exp = expectation(description: "It's 7 seconds later.")
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 8)
        XCTAssertEqual(sut.currentPhase, PomodoroPhases.work)
        XCTAssertEqual(sut.currentPhaseTime, "0:00")
    }
    
    func testSwitchToShortBreakAfterOneLongBreakAndWorkTime() {
        let exp = expectation(description: "It's 8 seconds later")
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 10)
        XCTAssertEqual(sut.currentPhase, PomodoroPhases.shortBreak)
        XCTAssertEqual(sut.currentPhaseTime, "0:00")
    }
    
    /*
     
     - pomodoro switches between work and break phases, defined by provided settings, based on passed time
     1. test if pomodoro switches to short break if defined work time ends
     2. test if pomodoro switches to work if defined short break time ends
     3. test if pomodoro switches to long break if defined number of short breaks ends
     4. test if pomodoro switches to work if defined long break time ends
     5. test if pomodoro switches to short break if defined work time after long break ends
 
    */
    
}
