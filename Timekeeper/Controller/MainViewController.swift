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
    
    let clockwork = PomodoroClockwork(
        settings: ClockSettings(
            workTimeDuration: 5,
            shortBreakDuration: 2,
            longBreakDuration: 3,
            shortBreaksCount: 4)
    )

    
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
                finishButton.setTitleColor(UIColor(red:0.73, green:0.88, blue:0.98, alpha:1.0), for: .normal)
                pauseButton.setTitleColor(UIColor(red:0.73, green:0.88, blue:0.98, alpha:1.0), for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoList.loadToDoList()
        
        [toDoListButton, pauseButton, finishButton, settingsButton].forEach {
            $0.layer.cornerRadius = 30
        }
        
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.widthAnchor.constraint(equalTo: circleProgressView.heightAnchor).isActive = true
        pauseButton.setTitle("Start", for: .normal)
        
        finishButton.isEnabled = false
        pauseButton.isEnabled = false
        
        //clockwork.createTimer()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        settings.loadAllSettings()
    }

    @IBAction func openToDoList(_ sender: UIButton) {
        performSegue(withIdentifier: "showToDoList", sender: self)
    }
    
    @IBAction func stopAndStartClockwork(_ sender: UIButton) {
        
        clockworkIsOn = !clockworkIsOn
        
        //clockwork.runTimer()
        
    
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
            taskLabel.text = "All your tasks are complete!"
            taskIdentifier = 0
            finishButton.isEnabled = false
            pauseButton.isEnabled = false
        }

    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        
        
        
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showToDoList" {
            let destinationVC = segue.destination as? ToDoListTableViewController
            destinationVC?.mainViewContentUpdateDelegate = self
        } else if segue.identifier == "showSettings" {
            let destinationVC = segue.destination as? SettingsTableViewController
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

extension MainViewController: MainViewContentUpdateDelegate {
    
    func updateTaskLabel(with taskID: Int64) {
        toDoList.loadToDoList()
        let indexNumber = toDoList.searchForTask(idNumber: taskID)
        taskLabel.text = toDoList.tasks[indexNumber!].descriptionOfTask
        taskIdentifier = taskID
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

