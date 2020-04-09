//
//  SettingsElements.swift
//  TimekeeperUITests
//
//  Created by Piotr Kłobukowski on 30/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest

class SettingsElements {
    let table: XCUIElement
    let settingPickerView: XCUIElement
    let component: XCUIElement
    let minutesComponent: XCUIElement
    let secondsComponent: XCUIElement
    let saveButton: XCUIElement
    let playButton: XCUIElement
    let backButton: XCUIElement
    let settingCells: Cells
    let alert: XCUIElement
    
    init(app: XCUIApplication) {
        self.table = app.tables.firstMatch
        self.settingPickerView = app.pickers.firstMatch
        self.saveButton = app.buttons[Controls.Buttons.save]
        self.playButton = app.buttons[Controls.Buttons.playSound]
        let navigationBar = app.navigationBars.firstMatch
        self.backButton = navigationBar.buttons[Controls.Buttons.back]
        self.component = app.pickerWheels.firstMatch
        self.minutesComponent = {
            let predicate = NSPredicate(format: "label BEGINSWITH '\(Controls.PickerComponents.minutes)'")
            let component = app.pickers.firstMatch.pickerWheels.element(matching: predicate)
            return component
        }()
        self.secondsComponent = {
            let predicate = NSPredicate(format: "label BEGINSWITH '\(Controls.PickerComponents.seconds)'")
            let component = app.pickers.firstMatch.pickerWheels.element(matching: predicate)
            return component
        }()
        self.settingCells = Cells(table: table)
        self.alert = app.alerts[Controls.Alerts.notMuchTime]
    }
    
    struct Cells {
        let focusTime: XCUIElementQuery
        let shortBreakTime: XCUIElementQuery
        let longBreakTime: XCUIElementQuery
        let shortBreaksAmount: XCUIElementQuery
        let alertSound: XCUIElementQuery
        
        init(table: XCUIElement) {
            let predicateFocusTime = NSPredicate(format: "label BEGINSWITH '\(Controls.SettingsCells.FocusTimeDuration)'")
            let predicateShortBreakTime = NSPredicate(format: "label BEGINSWITH '\(Controls.SettingsCells.shortBreakDuration)'")
            let predicateLongBreakTime = NSPredicate(format: "label BEGINSWITH '\(Controls.SettingsCells.longBreakDuration)'")
            let predicateShortBreaksAmount = NSPredicate(format: "label BEGINSWITH '\(Controls.SettingsCells.shortBreaksAmount)'")
            let predicateSound = NSPredicate(format: "label BEGINSWITH '\(Controls.SettingsCells.alertSound)'")
            
            self.focusTime = table.cells.containing(predicateFocusTime)
            self.shortBreakTime = table.cells.containing(predicateShortBreakTime)
            self.longBreakTime = table.cells.containing(predicateLongBreakTime)
            self.shortBreaksAmount = table.cells.containing(predicateShortBreaksAmount)
            self.alertSound = table.cells.containing(predicateSound)
        }
    }
    
    func changeSettings(for element: XCUIElement, of settingsElements: SettingsElements, withMinutes minutes: String?, andSeconds seconds: String?, or breaksAmount: String?) {
        element.tap()
        
        if let min = minutes, let sec = seconds {
            settingsElements.minutesComponent.adjust(toPickerWheelValue: min)
            settingsElements.secondsComponent.adjust(toPickerWheelValue: sec)
        }
        
        if let brksAmnt = breaksAmount {
            settingsElements.component.adjust(toPickerWheelValue: brksAmnt)
        }
        
        settingsElements.saveButton.tap()
    }
}
