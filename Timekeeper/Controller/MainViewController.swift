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
    
    @IBOutlet var toDoListButton: UIButton!
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var circleProgressView: CircleProgressView!
    
    @IBOutlet var clockworkLabel: UILabel!
    @IBOutlet var breaksLabel: UILabel!
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
        
        print(circleProgressView.frame.width)
        print(circleProgressView.frame.height)
        
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.widthAnchor.constraint(equalTo: circleProgressView.heightAnchor).isActive = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openToDoList(_ sender: UIButton) {
        performSegue(withIdentifier: "showToDoList", sender: self)
    }
    
    @IBAction func stopAndStartClockwork(_ sender: UIButton) {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] Timer in
            
        }
        
    }
    
    @IBAction func finishTask(_ sender: UIButton) {
        
    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        
        
        
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showToDoList" {
            let destinationVC = segue.destination as! ToDoListTableViewController
            destinationVC.toDoList = toDoList
            destinationVC.mainViewContentUpdateDelegate = self
        } else if segue.identifier == "showSettings" {
            let destinationVC = segue.destination as! SettingsTableViewController
            
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




