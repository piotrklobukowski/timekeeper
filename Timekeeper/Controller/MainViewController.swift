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
    
    let clockwork = Clockwork(settings: ClockSettings(workTimeDuration: 5, shortBreakDuration: 2, longBreakDuration: 3, shortBreaksLimit: 3, longBreaksLimit: 2))

    
    var clockworkIsOn = false {
        didSet {
            if !clockworkIsOn {
                pauseButton.setTitle(String.resume, for: .normal)
            } else {
                pauseButton.setTitle(String.pause, for: .normal)
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
                finishButton.setTitleColor(UIColor.fontColor, for: .normal)
                pauseButton.setTitleColor(UIColor.fontColor, for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoList.loadToDoList()
       
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.widthAnchor.constraint(equalTo: circleProgressView.heightAnchor).isActive = true
        pauseButton.setTitle(String.start, for: .normal)
        
        finishButton.isEnabled = false
        pauseButton.isEnabled = false
        
        clockwork.createTimer()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        settings.loadAllSettings()
    }

    @IBAction func openToDoList(_ sender: UIButton) {
        performSegue(withIdentifier: String.storyboardIdentifiers.segueShowToDoList.identifier, sender: self)
    }
    
    @IBAction func stopAndStartClockwork(_ sender: UIButton) {
        
        if !clockworkIsOn {
            clockworkIsOn = true
        } else {
            clockworkIsOn = false
        }
        
        clockwork.runTimer()
        
    
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
        
        
        
        performSegue(withIdentifier: String.storyboardIdentifiers.segueShowSettings.identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String.storyboardIdentifiers.segueShowToDoList.identifier {
            let destinationVC = segue.destination as? ToDoListTableViewController
            destinationVC?.mainViewContentUpdateDelegate = self
        } else if segue.identifier == String.storyboardIdentifiers.segueShowSettings.identifier {
            let destinationVC = segue.destination as? SettingsTableViewController
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
