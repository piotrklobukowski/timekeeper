//
//  ViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 09/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import CircleProgressView

class MainViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet var toDoListButton: UIButton!
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var circleProgressView: CircleProgressView!
    @IBOutlet var clockworkLabel: UILabel!
    @IBOutlet var breaksLabel: UILabel!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    var toDoList = ToDoList()
    var settings = Settings()
    
    var pomodoroClockwork: PomodoroClockwork?

    
    var clockworkIsOn = false {
        didSet {
            if clockworkIsOn {
                pauseButton.setTitle("Pause", for: .normal)
            } else {
                pauseButton.setTitle("Continue", for: .normal)
            }
        }
    }
    
    
    
    var taskIdentifier: Int64 = 0 {
        didSet {
            if taskIdentifier == 0 {
                finishButton.isEnabled = false
                pauseButton.isEnabled = false
            } else {
                finishButton.isEnabled = true
                pauseButton.isEnabled = true
            }
        }
    }
    
    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        toDoList.loadToDoList()
        settings.loadAllSettings()
        
        pomodoroClockwork = PomodoroClockwork(settings:
            ClockSettings(
                workTimeDuration: settings.durationSettings[0].amount,
                shortBreakDuration: settings.durationSettings[2].amount,
                longBreakDuration: settings.durationSettings[1].amount,
                shortBreaksCount: Int(settings.breaksNumberSetting[1].amount)))

        pomodoroClockwork?.delegate = self
        
        [toDoListButton, pauseButton, finishButton, settingsButton].forEach {
            $0.layer.cornerRadius = 30
        }
        
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.widthAnchor.constraint(equalTo: circleProgressView.heightAnchor).isActive = true
        pauseButton.setTitle("Start", for: .normal)
        clockworkLabel.text = formatter.string(from: settings.durationSettings[0].amount)
        
        finishButton.isEnabled = false
        pauseButton.isEnabled = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func openToDoList(_ sender: UIButton) {
        performSegue(withIdentifier: String.StoryboardIdentifiers.segueShowToDoList.rawValue, sender: self)
    }
    
    @IBAction func stopAndStartClockwork(_ sender: UIButton) {
        
        clockworkIsOn = !clockworkIsOn
        clockworkIsOn ? pomodoroClockwork?.start() : pomodoroClockwork?.pause()
        
    }
    
    @IBAction func finishTask(_ sender: UIButton) {
        toDoList.taskIsDone(id: taskIdentifier)
        
        let task = toDoList.tasks.first {
            $0.isDone == false
        }
        
        if let nextTask = task {
            taskLabel.text = nextTask.descriptionOfTask
            taskIdentifier = nextTask.identifier
        } else {
            taskLabel.text = String.finishText
            taskIdentifier = 0
            finishButton.isEnabled = false
            pauseButton.isEnabled = false
        }

    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        performSegue(withIdentifier: String.StoryboardIdentifiers.segueShowSettings.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String.StoryboardIdentifiers.segueShowToDoList.rawValue {
            let destinationVC = segue.destination as? ToDoListTableViewController
            destinationVC?.mainViewContentUpdateDelegate = self
        }
    }

}

extension MainViewController: MainViewContentUpdateDelegate {
    
    func updateTaskLabel(with taskID: Int64) {
        toDoList.loadToDoList()
        guard let indexNumber = toDoList.searchForTask(idNumber: taskID) else { return }
        taskLabel.text = toDoList.tasks[indexNumber].descriptionOfTask
        taskIdentifier = taskID
    }
    
}

extension MainViewController: PomodoroClockworkDelegate {
    
    func updateTimeInClockworkLabel(currentTime: CFTimeInterval, phase: PomodoroPhases) {
        let endTime: Double = {
            var newValue: Double
            switch phase {
            case .work:
                newValue = settings.durationSettings[0].amount
            case .shortBreak:
                newValue = settings.durationSettings[2].amount
            case .longBreak:
                newValue = settings.durationSettings[1].amount
            }
            return newValue
        }()
        
        let roundedCurrentTime = currentTime.rounded()
        let countdown = endTime - roundedCurrentTime
        
        var newProgress: Double {
            var newProgress = roundedCurrentTime/endTime
            if newProgress > 1.0 {
                newProgress = 1.0
            }
            return newProgress
        }
        
        clockworkLabel.text = formatter.string(from: countdown)
        circleProgressView.setProgress(newProgress, animated: true)
    }
    
    func changeBreakInformationLabel(phase: PomodoroPhases, numberOfShortBreaks: Int?) {
        switch phase {
        case .work:
            clockworkLabel.text = formatter.string(from: settings.durationSettings[0].amount)
            breaksLabel.text = "Short Breaks: \(numberOfShortBreaks ?? 0)/\(Int(settings.breaksNumberSetting[1].amount))"
        case .shortBreak:
            clockworkLabel.text = formatter.string(from: settings.durationSettings[1].amount)
            breaksLabel.text = "Short Break"
        case .longBreak:
            clockworkLabel.text = formatter.string(from: settings.durationSettings[2].amount)
            breaksLabel.text = "Long Break"
        }
    }

    
}

extension UIButton {
    override open var isHighlighted : Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red:0.20, green:0.51, blue:0.72, alpha:1.0)
                : UIColor(red:0.06, green:0.30, blue:0.46, alpha:1.0)
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor(red:0.06, green:0.30, blue:0.46, alpha:1.0) : UIColor.darkGray
            
        }
    }

}

