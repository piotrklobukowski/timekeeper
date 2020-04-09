//
//  ClockTest.swift
//  TimekeeperTests
//
//  Created by Piotr Kłobukowski on 25/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class ClockTest: XCTestCase {
    
    var sut: Clock!
    
    override func setUp() {
        super.setUp()
        sut = Clock()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testTimeFormatToTextProperrly() {
        let exp = expectation(description: "It's 2 seconds later")
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 3)
        XCTAssertEqual(sut.currentTimeText, "00:02")
    }
    
    func testClockChangesAfterOneSecond() {
        let exp = expectation(description: "It's one second later")
        sut.startTimer()
        let time = sut.currentTime
        let currentTimeText = sut.currentTimeText
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 2)
        XCTAssertNotNil(time)
        XCTAssertNotEqual(time, sut.currentTime)
        XCTAssertNotEqual(currentTimeText, sut.currentTimeText)
    }
    
    func testClockDoesntChangeIfTimeFromLastChangeIsLessThanOneSecond() {
        let exp = expectation(description: "It's less than one second later")
        sut.startTimer()
        let time = sut.currentTime
        let currentTimeText = sut.currentTimeText
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1)
        XCTAssertNotNil(currentTimeText)
        XCTAssertNotNil(time)
        XCTAssertEqual(currentTimeText, sut.currentTimeText)
        XCTAssertEqual(time, sut.currentTime)
    }
    
    func testClockPauseFunctionalityWorksProperrly() {
        let exp1 = expectation(description: "It's one second later")
        let exp2 = expectation(description: "It's one second later")
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp1.fulfill()
        })
        wait(for: [exp1], timeout: 2)
        let time = sut.currentTime
        let currentTimeText = sut.currentTimeText
        sut.pauseTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp2.fulfill()
        })
        wait(for: [exp2], timeout: 2)
        XCTAssertNotNil(time)
        XCTAssertNotNil(currentTimeText)
        XCTAssertEqual(time, sut.currentTime)
        XCTAssertEqual(currentTimeText, sut.currentTimeText)
    }
    
    func testClockPauseAndContinueWorksProperrly() {
        let exp1 = expectation(description: "It's one second later")
        let exp2 = expectation(description: "It's one second later")
        let exp3 = expectation(description: "It's one second later")
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp1.fulfill()
        })
        wait(for: [exp1], timeout: 2)
        let time = sut.currentTime
        let currentTimeText = sut.currentTimeText
        sut.pauseTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp2.fulfill()
        })
        wait(for: [exp2], timeout: 2)
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp3.fulfill()
        })
        wait(for: [exp3], timeout: 2)
        XCTAssertNotNil(time)
        XCTAssertNotNil(currentTimeText)
        XCTAssertNotEqual(time, sut.currentTime)
        XCTAssertNotEqual(currentTimeText, sut.currentTimeText)
    }
    
    func testTerminateTimer() {
        let exp = expectation(description: "It's 1 second later")
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp.fulfill()
        })
        wait(for: [exp], timeout: 2)
        let time = sut.currentTime
        let currentTimeText = sut.currentTimeText
        sut.terminateTimer()
        XCTAssertNotEqual(time, sut.currentTime)
        XCTAssertNotEqual(currentTimeText, sut.currentTimeText)
        XCTAssertNil(sut.currentTime)
        XCTAssertNil(sut.currentTimeText)
    }
    
    func testTerminateAndStartAnotherTimerProperrly() {
        let exp1 = expectation(description: "It's 1 second later")
        let exp2 = expectation(description: "It's 1 second later")
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp1.fulfill()
        })
        wait(for: [exp1], timeout: 2)
        sut.terminateTimer()
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            exp2.fulfill()
        })
        wait(for: [exp2], timeout: 2)
        XCTAssertNotNil(sut.currentTime)
        XCTAssertNotNil(sut.currentTimeText)
    }
    
}
