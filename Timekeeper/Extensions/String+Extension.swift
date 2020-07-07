//
//  String+Extension.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 24/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

extension String {
    
    static var timeSixty: [String] {
        return (0..<60).map { String(format: "%02d", $0) }
    }
    
    static var breaksAmount: [String] {
        return (1..<10).map { String($0) }
    }
    
    static var sounds: [String] {
        return ["Bell Sound Ring", "Front Desk Bells", "Japanese Temple Bell Small", "Ship Bell"]
    }
    
    enum StoryboardIdentifiers: String {
        case main = "Main"
        case segueOpenDurationSettings = "OpenDurationSettings"
        case segueOpenBreaksAmountSettings = "OpenBreakAmountSettings"
        case segueOpenSoundSettings = "OpenSoundSettings"
        case segueOpenCredits = "OpenCredits"
        case segueShowToDoList = "showToDoList"
        case segueShowSettings = "showSettings"
        case toDoListCell = "Task Cell"
        case settingCell = "Setting Cell"
        case toDoListTableViewControllerID = "ToDoListTableViewControllerID"
        case settingsTableViewControllerID =
        "SettingsTableViewControllerID"
        case durationSettingsViewControllerID =
        "DurationSettingsViewControllerID"
        case breaksAmountSettingsViewControllerID =
        "BreaksAmountSettingsViewControllerID"
        case soundSettingsViewControllerID =
        "SoundSettingsViewControllerID"
        
    }
    
    enum CoreData: String {
        case dataModel = "DataModel"
        case amountKey = "amount"
        case descriptionOfSettingKey = "descriptionOfSetting"
        case idKey = "id"
        case settingStringKey = "settingString"
    }
    
    static let resume = "Continue"
    static let start = "Start"
    static let pause = "Pause"
    static let finishText = "All your tasks are complete!"
    static let welcomeText = "Choose task from To-do list"
    static let toDoListTitle = "Your To-do List"
    static let addTask = "Add task"
    static let add = "Add"
    static let cancel = "Cancel"
    
    
}
