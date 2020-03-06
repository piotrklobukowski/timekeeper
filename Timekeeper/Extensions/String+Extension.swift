//
//  String+Extension.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 24/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

extension String {
    
    static var timeSixty: [String] {
        return (0..<60).map { String(format: "%02d", $0) }
    }
    
    static var breaksAmount: [String] {
        return (0..<10).map { String($0) }
    }
    
    enum storyboardIdentifiers: String {
        case segueOpenDurationSettings
        case segueOpenBreaksAmountSettings
        case segueOpenSoundSettings
        case segueOpenCredits
        case segueShowToDoList
        case segueShowSettings
        case toDoListCell
        case settingCell
        
        var identifier: String {
            switch self {
            case .segueOpenDurationSettings:
                return "OpenDurationSettings"
            case .segueOpenBreaksAmountSettings:
                return "OpenBreakAmountSettings"
            case .segueOpenSoundSettings:
                return "OpenSoundSettings"
            case .segueOpenCredits:
                return "OpenCredits"
            case .segueShowToDoList:
                return "showToDoList"
            case .segueShowSettings:
                return "showSettings"
            case .toDoListCell:
                return "Task Cell"
            case .settingCell:
                return "Setting Cell"
            }
        }
    }
    
    static let dataModel = "DataModel"
    
    static let resume = "Continue"
    static let start = "Start"
    static let pause = "Pause"
    static let finishText = "All your tasks are complete!"
    static let toDoListTitle = "Your To-do List"
    static let addTask = "Add task"
    static let add = "Add"
    static let cancel = "Cancel"
    
    
}
