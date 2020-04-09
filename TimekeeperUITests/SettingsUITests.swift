//
//  SettingsUITests.swift
//  TimekeeperUITests
//
//  Created by Piotr Kłobukowski on 21/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import Timekeeper

class SettingsUITests: XCTestCase {
    
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
    
    func testSettingsChanges_UpdatesMainViewWhenClockDoesntWorking() {
        let settingsElements = SettingsElements(app: app)
        let mainViewElements = MainViewElements(app: app)
        
        mainViewElements.settingsButton.tap()
        settingsElements.settingCells.focusTime.element.tap()
        
        let minutesValue = settingsElements.minutesComponent.value as! String
        let secondsValue = settingsElements.secondsComponent.value as! String
        
        XCTAssertEqual(app.staticTexts.firstMatch.label,
                       Controls.SettingsCells.FocusTimeDuration)
        XCTAssertEqual(minutesValue, "00")
        XCTAssertEqual(secondsValue, "25")
        
        settingsElements.minutesComponent.adjust(toPickerWheelValue: "01")
        settingsElements.secondsComponent.adjust(toPickerWheelValue: "05")
        settingsElements.saveButton.tap()

        XCTAssertTrue(settingsElements.settingCells.focusTime.staticTexts["01:05"].exists)
        
        settingsElements.settingCells.shortBreaksAmount.element.tap()
        let breaksValue = settingsElements.settingPickerView.pickerWheels.firstMatch.value as! String
        
        XCTAssertEqual(app.staticTexts.firstMatch.label,
                       Controls.SettingsCells.shortBreaksAmount)
        XCTAssertEqual(breaksValue, "3")
        
        settingsElements.component.adjust(toPickerWheelValue: "7")
        settingsElements.saveButton.tap()
        
        XCTAssertTrue(settingsElements.settingCells.shortBreaksAmount.staticTexts["7"].exists)
        
        settingsElements.backButton.tap()
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "01:05")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 0/7")
    }
    
    func testSoundSettings() {
        let settingsElements = SettingsElements(app: app)
        let mainViewElements = MainViewElements(app: app)
        
        mainViewElements.settingsButton.tap()
        settingsElements.settingCells.alertSound.element.tap()
        
        let soundDefaultValue = settingsElements.component.value as! String
        
        XCTAssertEqual(app.staticTexts.firstMatch.label, Controls.SettingsCells.alertSound)
        XCTAssertEqual(soundDefaultValue, "Bell Sound Ring")
        XCTAssertTrue(app.buttons[Controls.Buttons.playSound].isEnabled)
        
        settingsElements.playButton.tap()
        
        XCTAssertFalse(app.buttons[Controls.Buttons.playSound].isEnabled)
        sleep(4)
        
        XCTAssertTrue(app.buttons[Controls.Buttons.playSound].isEnabled)
        
        settingsElements.component.adjust(toPickerWheelValue: "Japanese Temple Bell Small")
        settingsElements.playButton.tap()
        sleep(4)
        settingsElements.saveButton.tap()
        settingsElements.settingCells.alertSound.element.tap()
        
        let soundValue = settingsElements.component.value as! String
        XCTAssertEqual(soundValue, "Japanese Temple Bell Small")
        settingsElements.playButton.tap()
        sleep(4)
    }
    
    func testForceUserChooseMinimalValue() {
        let settingsElements = SettingsElements(app: app)
        
        app.buttons[Controls.Buttons.settings].tap()
        provideValueLessThanMinimalValue(for: settingsElements.settingCells.focusTime.element, of: settingsElements)
        XCTAssertFalse(settingsElements.settingCells.focusTime.staticTexts["00:00"].exists)
        XCTAssertTrue(settingsElements.settingCells.focusTime.staticTexts["00:05"].exists)

        
        provideValueLessThanMinimalValue(for: settingsElements.settingCells.shortBreakTime.element, of: settingsElements)
        XCTAssertFalse(settingsElements.settingCells.shortBreakTime.staticTexts["00:00"].exists)
        XCTAssertTrue(settingsElements.settingCells.shortBreakTime.staticTexts["00:05"].exists )
        
        provideValueLessThanMinimalValue(for: settingsElements.settingCells.longBreakTime.element, of: settingsElements)
        
        XCTAssertFalse(settingsElements.settingCells.longBreakTime.staticTexts["00:00"].exists)
        XCTAssertTrue(settingsElements.settingCells.longBreakTime.staticTexts["00:05"].exists)
        
    }
    
    func testSettingsChanges_ClockWorksUsingGivenChanges() {
        let settingsElements = SettingsElements(app: app)
        let mainViewElements = MainViewElements(app: app)
        let toDoListElements = ToDoListElements(app: app, numberOfCells: 1)
        let exp1FocusTime = expectation(description: "First focus time passed")
        let exp1shortBreak = expectation(description: "First short break passed")
        let exp2FocusTime = expectation(description: "Second focus time passed")
        let exp2shortBreak = expectation(description: "Second short break passed")
        let exp3FocusTime = expectation(description: "Third focus time passed")
        
        mainViewElements.settingsButton.tap()
        settingsElements.changeSettings(for: settingsElements.settingCells.focusTime.element, of: settingsElements, withMinutes: "00", andSeconds: "10", or: nil)
        settingsElements.changeSettings(for: settingsElements.settingCells.shortBreakTime.element, of: settingsElements, withMinutes: "00", andSeconds: "06", or: nil)
        settingsElements.changeSettings(for: settingsElements.settingCells.longBreakTime.element, of: settingsElements, withMinutes: "00", andSeconds: "07", or: nil)
        settingsElements.changeSettings(for: settingsElements.settingCells.shortBreaksAmount.element, of: settingsElements, withMinutes: nil, andSeconds: nil, or: "2")
        settingsElements.backButton.tap()
        
        mainViewElements.toDoListButton.tap()
        toDoListElements.addTask(name: "test")
        toDoListElements.cells[0].tap()
        
        mainViewElements.clockOnButton.tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            exp1FocusTime.fulfill()
        }
        wait(for: [exp1FocusTime], timeout: 10)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:06")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Break")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            exp1shortBreak.fulfill()
        }
        wait(for: [exp1shortBreak], timeout: 6)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:10")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 1/2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            exp2FocusTime.fulfill()
        }
        wait(for: [exp2FocusTime], timeout: 10)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:06")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Break")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            exp2shortBreak.fulfill()
        }
        wait(for: [exp2shortBreak], timeout: 6)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:10")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Short Breaks: 2/2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            exp3FocusTime.fulfill()
        }
        wait(for: [exp3FocusTime], timeout: 10)
        
        XCTAssertEqual(mainViewElements.clockworkLabel.label, "00:07")
        XCTAssertEqual(mainViewElements.breaksLabel.label, "Long Break")
    }
    
    private func provideValueLessThanMinimalValue(for element: XCUIElement, of settingsElements: SettingsElements) {
        element.tap()
        settingsElements.minutesComponent.adjust(toPickerWheelValue: "00")
        settingsElements.secondsComponent.adjust(toPickerWheelValue: "00")
        
        let minutesValue = settingsElements.minutesComponent.value as! String
        let secondsValue = settingsElements.secondsComponent.value as! String
        
        XCTAssertEqual(minutesValue, "00")
        XCTAssertEqual(secondsValue, "05")
        
        settingsElements.saveButton.tap()
    }
    
}
