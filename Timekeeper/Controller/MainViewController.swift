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
    var clockworkSettings = ClockworkSettings()
   
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttons = [toDoListButton, pauseButton, finishButton, settingsButton]
        
        buttons.forEach { button in
            button?.layer.cornerRadius = 30
        }
        
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.widthAnchor.constraint(equalTo: circleProgressView.heightAnchor).isActive = true
        pauseButton.setTitle("Start", for: .normal)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func openToDoList(_ sender: UIButton) {
        performSegue(withIdentifier: "showToDoList", sender: self)
    }
    
    @IBAction func stopAndStartClockwork(_ sender: UIButton) {
        
        var minutes = self.minutes
        var seconds = self.seconds
        var shortBreaksAmount = self.shortBreaksAmount
        
        let workTimer = Timer.init(timeInterval: 1.0, repeats: true) {
            [weak self] (Timer) in
            
            if !(self?.clockworkIsOn)! {
                Timer.invalidate()
                print("""
                    minutes \(minutes)
                    seconds \(seconds)
                    """)
                self?.minutes = minutes
                self?.seconds = seconds
            } else {
                print("\(minutes):\(seconds)")
            }
            
            if seconds > 0 {
                seconds -= 1
            } else if minutes > 0 {
                seconds = 10
                minutes -= 1
            } else {
                Timer.invalidate()
                print("timer ends")
            }
            
        }
        
        if !clockworkIsOn {
            clockworkIsOn = true
        } else {
            clockworkIsOn = false
        }
        print(clockworkIsOn)

        
        if clockworkIsOn {
            RunLoop.current.add(workTimer, forMode: .commonModes)
        }
        
        
        
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
    
    }
    
    @IBAction func finishTask(_ sender: UIButton) {
        
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
    
    func updateTaskLabel(with title: String) {
        taskLabel.text = title
    }
    
}



