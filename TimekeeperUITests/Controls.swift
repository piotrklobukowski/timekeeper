//
//  Controls.swift
//  TimekeeperUITests
//
//  Created by Piotr Kłobukowski on 21/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct Controls {
    struct Buttons {
        static var ok: String = "OK"
        static var toDoList: String = "To-Do List"
        static var add: String = "Add"
        static var cancel: String = "Cancel"
        static var finishTask: String = "Finish Task"
        static var start: String = "pauseButton"
        static var delete: String = "Delete"
        static var settings: String = "Settings"
        static var save: String = "Save"
        static var back: String = "Back"
        static var playSound: String = "Play sound"
    }
    
    struct NavigationBars {
        static var yourToDoList = "Your To-do List"
    }
    
    struct Alerts {
        static var addTask = "Add task"
        static var notMuchTime = "Not much time"
    }
    
    struct Tables {
        static var emptyList = "Empty list"
    }
    
    struct SettingsCells {
        static var FocusTimeDuration = "Duration of focus time"
        static var shortBreakDuration = "Duration of short break"
        static var longBreakDuration = "Duration of long break"
        static var shortBreaksAmount = "Number of short breaks"
        static var alertSound = "Sound for alert"
    }
    
    struct PickerComponents {
        static var minutes = "minutes"
        static var seconds = "seconds"
    }
    
    struct Labels {
        static var clockworkLabel = "clockworkLabel"
        static var breaksLabel = "breaksLabel"
    }
    
}
