//
//  MainViewElements.swift
//  TimekeeperUITests
//
//  Created by Piotr Kłobukowski on 30/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest

class MainViewElements {
    let toDoListButton: XCUIElement
    let settingsButton: XCUIElement
    let clockOnButton: XCUIElement
    let clockworkLabel: XCUIElement
    let breaksLabel: XCUIElement
    
    init(app: XCUIApplication) {
        self.toDoListButton = app.buttons[Controls.Buttons.toDoList]
        self.settingsButton = app.buttons[Controls.Buttons.settings]
        self.clockOnButton = app.buttons[Controls.Buttons.start]
        self.clockworkLabel = app.staticTexts[Controls.Labels.clockworkLabel]
        self.breaksLabel = app.staticTexts[Controls.Labels.breaksLabel]
    }
}
