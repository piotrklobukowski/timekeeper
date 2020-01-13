//
//  ViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 09/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var toDoListButton: UIButton!
    @IBOutlet var TaskLabel: UILabel!
    @IBOutlet var clockView: UIImageView!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    var clockwork = Clockwork()
    var toDoList = ToDoList()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttons = [toDoListButton, pauseButton, finishButton, settingsButton]
        
        buttons.forEach { button in
            button?.layer.cornerRadius = 30
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openToDoList(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showToDoList", sender: self)
        
        
    }
    
    @IBAction func stopAndStartClockwork(_ sender: UIButton) {
    }
    
    @IBAction func finishTask(_ sender: UIButton) {
    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
}


class Clockwork {
    var workTime: Int = 25
    var shortBreakTime: Int = 5
    var longBreakTime: Int = 20
    var shortBreaksAmount: Int = 3
    var longBreaksAmount: Int = 1
    
}

struct Task {
    let name: String
    var isDone: Bool
}

class ToDoList {
    var tasks = [Task]()
    
}
