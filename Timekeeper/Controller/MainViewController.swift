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
    var clockwork = Clockwork(workTime: 10, shortBreakDuration: 5, longBreakDuration: 8, shortBreaksLimit: 3, longBreaksLimit: 1)
    var settings = Settings()
    
    var clockworkIsOn = false {
        didSet {
            if !clockworkIsOn {
                pauseButton.setTitle("Continue", for: .normal)
            } else {
                pauseButton.setTitle("Pause", for: .normal)
            }
        }
    }
    
    
    
    var minutes = 8
    var seconds = 12
    var shortBreaksAmount = 0
    
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
        
        let buttons = [toDoListButton, pauseButton, finishButton, settingsButton]
        
        buttons.forEach { button in
            button?.layer.cornerRadius = 30
        }
        
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.widthAnchor.constraint(equalTo: circleProgressView.heightAnchor).isActive = true
        pauseButton.setTitle("Start", for: .normal)
        
        finishButton.isEnabled = false
        pauseButton.isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        settings.loadAllSettings()
        settings.addDefaultSettings()
    }

    @IBAction func openToDoList(_ sender: UIButton) {
        performSegue(withIdentifier: "showToDoList", sender: self)
    }
    
    @IBAction func stopAndStartClockwork(_ sender: UIButton) {
        
        if !clockworkIsOn {
            clockworkIsOn = true
        } else {
            clockworkIsOn = false
        }
        
        clockwork.didTapButton(sender)
        
        
    
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

extension MainViewController: MainViewContentUpateDelegate {
    
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

class Clockwork {

    var timer: DispatchSourceTimer?


    let workTimeDuration: Double
    let shortBreakDuration: Double
    let longBreakDuration: Double
    let shortBreaksLimit: Int
    let longBreaksLimit: Int
    var shortBreaksElapsed = 0
    var longBreaksElapsed = 0

    init(workTime: Double, shortBreakDuration: Double, longBreakDuration: Double, shortBreaksLimit: Int, longBreaksLimit: Int) {
        workTimeDuration = workTime
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.shortBreaksLimit = shortBreaksLimit
        self.longBreaksLimit = longBreaksLimit
    }
    
    


    func createTimer() {
        
        //var endTime: Double

        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: 0.1)
        timer?.setEventHandler { [weak self] in
            guard let start = self?.start else { return }
            
            let elapsed = (self?.totalElapsed ?? 0) + CACurrentMediaTime() - start
            print(elapsed)
            
            
//            if elapsed >= endTime {
//                self?.pauseTimer()
//                self?.start = nil
//                self?.totalElapsed = nil
//                self?.cancelTimer()
//            }
         
        }

    }

    var start: CFTimeInterval?         // if nil, timer not running
    var totalElapsed: CFTimeInterval?

    @objc func didTapButton(_ button: UIButton) {
        if start == nil {
            startTimer()
        } else {
            pauseTimer()
        }
    }

    private func startTimer() {
        start = CACurrentMediaTime()
        timer?.resume()
    }

    private func pauseTimer() {
        timer?.suspend()
        totalElapsed = (totalElapsed ?? 0) + (CACurrentMediaTime() - start!)
        start = nil
    }

    private func cancelTimer() {
        timer?.cancel()
    }

}

//var minutes = self.minutes
//var seconds = self.seconds
//var shortBreaksAmount = self.shortBreaksAmount

//let workTimer = Timer.init(timeInterval: 1.0, repeats: true) {
//            [weak self] (Timer) in
//
//            if !(self?.clockworkIsOn)! {
//                Timer.invalidate()
//                print("""
//                    minutes \(minutes)
//                    seconds \(seconds)
//                    """)
//                self?.minutes = minutes
//                self?.seconds = seconds
//            } else {
//                print("\(minutes):\(seconds)")
//            }
//
//            if seconds > 0 {
//                seconds -= 1
//            } else if minutes > 0 {
//                seconds = 10
//                minutes -= 1
//            } else {
//                Timer.invalidate()
//                print("timer ends")
//            }
//
//        }
//
//        if !clockworkIsOn {
//            clockworkIsOn = true
//        } else {
//            clockworkIsOn = false
//        }
//        print(clockworkIsOn)
//
//
//        if clockworkIsOn {
//            RunLoop.current.add(workTimer, forMode: .commonModes)
//        }



//        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
//            print("\(minutes):\(seconds)")
//
//            if !self!.clockworkIsOn {
//                timer.invalidate()
//            }
//
//            if seconds > 0 {
//                seconds -= 1
//            } else if minutes > 0 {
//                seconds = 10
//                minutes -= 1
//            } else {
//                timer.invalidate()
//                print("timer ends")
//            }
//        }

