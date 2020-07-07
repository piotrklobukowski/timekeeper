//
//  ViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 09/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import CircleProgressView
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet var toDoListButton: UIButton!
    @IBOutlet var circleProgressView: CircleProgressView!
    @IBOutlet var clockworkLabel: UILabel!
    @IBOutlet var breaksLabel: UILabel!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    var toDoList = ToDoList()
    var settings: Settings?
    var pomodoroClockwork: PomodoroClockwork?
    var player = AVPlayer()
    
    var clockworkIsOn = false {
        didSet {
            if clockworkIsOn == true {
                pauseButton.setTitle("Pause", for: .normal)
                settingsButton.isEnabled = false
            } else {
                pauseButton.setTitle("Continue", for: .normal)
                settingsButton.isEnabled = true
            }
        }
    }
    
    var taskIdentifier: Int64 = 0 {
        didSet {
            if taskIdentifier == 0 {
                finishButton.isEnabled = false
                pauseButton.isEnabled = false
                pomodoroClockwork?.terminate()
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
        setupSettings()
        settings?.loadAllSettings()
        toDoList.loadToDoList()
        
        pauseButton.setTitle("Start", for: .normal)
        finishButton.isEnabled = false
        pauseButton.isEnabled = false
        
        guard let workTime = settings?.durationSettings[0].amount,
            let shortBreakTime = settings?.durationSettings[1].amount,
            let longBreakTime = settings?.durationSettings[2].amount,
            let shortBreaksCount = settings?.breaksNumberSettings[0].amount else { return }
        
        pomodoroClockwork = PomodoroClockwork(settings:
            ClockSettings(
                workTimeDuration: workTime,
                shortBreakDuration: shortBreakTime,
                longBreakDuration: longBreakTime,
                shortBreaksCount: Int(shortBreaksCount)))
        
        clockworkLabel.text = formatter.clockFormat(from: workTime)
        breaksLabel.text = "Short Breaks: 0/\(pomodoroClockwork?.settings.shortBreaksCount ?? Int(shortBreaksCount))"
        
        pomodoroClockwork?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toDoList.loadToDoList()
        settings?.loadAllSettings()
    }
    
    private func setupSettings() {
        if settings == nil {
            settings = Settings()
        }
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
        
        guard let indexNumber = toDoList.searchForTask(idNumber: taskIdentifier) else { return }
        var nextTask: Task?
        
        if indexNumber != toDoList.tasks.index(before: toDoList.tasks.endIndex) {
            for taskIndex in toDoList.tasks.index(after: indexNumber)..<toDoList.tasks.endIndex {
                if toDoList.tasks[taskIndex].isDone == false {
                    nextTask = toDoList.tasks[taskIndex]
                    break
                }
            }
        } else {
            nextTask = toDoList.tasks.first {
                $0.isDone == false
            }
        }
        
        if let taskToShow = nextTask {
            self.navigationItem.title = taskToShow.descriptionOfTask
            taskIdentifier = taskToShow.identifier
        } else {
            self.navigationItem.title = String.finishText
            taskIdentifier = 0
            finishButton.isEnabled = false
            pauseButton.isEnabled = false
        }

    }
    
    @IBAction func openSettings(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: String.StoryboardIdentifiers.segueShowSettings.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String.StoryboardIdentifiers.segueShowToDoList.rawValue {
            let destinationVC = segue.destination as? ToDoListTableViewController
            destinationVC?.mainViewContentUpdateDelegate = self
        } else if segue.identifier == String.StoryboardIdentifiers.segueShowSettings.rawValue {
            let destinationVC = segue.destination as? SettingsTableViewController
            destinationVC?.mainVCdelegate = self
            destinationVC?.settings = settings
        }
    }

    private func play(url: URL) {
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player.play()
    }

}

extension MainViewController: MainViewContentUpdateDelegate {
    
    func updateMainVCwithSettings() {
        guard let workTime = settings?.durationSettings[0].amount,
            let shortBreakTime = settings?.durationSettings[1].amount,
            let longBreakTime = settings?.durationSettings[2].amount,
            let shortBreaksCount = settings?.breaksNumberSettings[0].amount else { return }

        pomodoroClockwork = PomodoroClockwork(settings: ClockSettings(
            workTimeDuration: workTime,
            shortBreakDuration: shortBreakTime,
            longBreakDuration: longBreakTime,
            shortBreaksCount: Int(shortBreaksCount)))
        
        pomodoroClockwork?.delegate = self
        resetDataForClockworkRepresentation(numberOfShortBreaks: 0)
    }
    
    func updateTaskLabel(with taskID: Int64) {
        toDoList.loadToDoList()
        guard let indexNumber = toDoList.searchForTask(idNumber: taskID) else {
            self.navigationItem.title = String.welcomeText
            return
        }
        self.navigationItem.title = toDoList.tasks[indexNumber].descriptionOfTask
        taskIdentifier = taskID
    }
    
}

extension MainViewController: PomodoroClockworkDelegate {
    
    func updateTimeInClockworkLabel(currentTime: CFTimeInterval, phase: PomodoroPhases) {
        guard let workTime = pomodoroClockwork?.settings.workTimeDuration, let shortBreakDuration = pomodoroClockwork?.settings.shortBreakDuration, let longBreakDuration = pomodoroClockwork?.settings.longBreakDuration else { return }
        
        let endTime: Double = {
            switch phase {
            case .work:
                return workTime
            case .shortBreak:
                return shortBreakDuration
            case .longBreak:
                return longBreakDuration
            }
        }()
        
        let countdown: Double = {
            return endTime - currentTime
        }()
        let newProgress: Double = {
            return currentTime/endTime
        }()
        
        print(currentTime)
        clockworkLabel.text = formatter.clockFormat(from: countdown)
        circleProgressView.setProgress(newProgress, animated: true)
    }
    
    func changeBreakInformationLabel(phase: PomodoroPhases, numberOfShortBreaks: Int?) {
        guard let workTime = pomodoroClockwork?.settings.workTimeDuration,
            let shortBreaksCount = pomodoroClockwork?.settings.shortBreaksCount,
            let shortBreakDuration = pomodoroClockwork?.settings.shortBreakDuration,
            let longBreakDuration = pomodoroClockwork?.settings.longBreakDuration,
            let alert = settings?.soundSettings[0].settingString,
            let url = Bundle.main.url(forResource: alert, withExtension: "mp3") else { return }
        
        play(url: url)
        
        switch phase {
        case .work:
            clockworkLabel.text = formatter.clockFormat(from: workTime)
            breaksLabel.text = "Short Breaks: \(numberOfShortBreaks ?? 0)/\(shortBreaksCount)"
        case .shortBreak:
            clockworkLabel.text = formatter.clockFormat(from: shortBreakDuration)
            breaksLabel.text = "Short Break"
        case .longBreak:
            clockworkLabel.text = formatter.clockFormat(from: longBreakDuration)
            breaksLabel.text = "Long Break"
        }
    }
    
    func resetDataForClockworkRepresentation(numberOfShortBreaks: Int) {
        guard let workTime = pomodoroClockwork?.settings.workTimeDuration, let shortBreaksCount = pomodoroClockwork?.settings.shortBreaksCount else { return }
        circleProgressView.setProgress(0.0, animated: true)
        clockworkIsOn = false
        pauseButton.setTitle("Start", for: .normal)
        clockworkLabel.text = formatter.clockFormat(from: workTime)
        breaksLabel.text = "Short Breaks: \(numberOfShortBreaks)/\(shortBreaksCount)"
    }
}

