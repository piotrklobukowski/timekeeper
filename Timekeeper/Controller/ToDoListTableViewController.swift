//
//  ToDoListTableViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 11/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    
    var toDoList = ToDoList()
    
    
    weak var mainViewContentUpdateDelegate: MainViewContentUpateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateToPresent = dateFormatter.string(from: Date())
        navigationItem.title = "Tasks for \(dateToPresent)"
        
        let addTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertForTaskAdding))

        navigationItem.rightBarButtonItem = addTaskButton
        

        
        toDoList.loadToDoList()
     

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        
//        navigationItem.rightBarButtonItem?.customView?.backgroundColor = UIColor(red:0.20, green:0.51, blue:0.72, alpha:1.0)

//        navigationItem.backBarButtonItem?.customView?.backgroundColor = UIColor(red:0.20, green:0.51, blue:0.72, alpha:1.0)
    }
    
    @objc func showAlertForTaskAdding() {
        let ac = UIAlertController(title: "Add task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            
            guard let taskDescription = ac?.textFields?[0].text else { return }
            
            self?.toDoList.addTask(description: taskDescription)
            
            let indexPath = IndexPath(row: ((self?.toDoList.tasks.count)! - 1), section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoList.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task Cell", for: indexPath)
        let task = toDoList.tasks[indexPath.row]

        cell.textLabel?.text = task.descriptionOfTask
        cell.accessoryType = task.isDone ? .checkmark : .none
        
//        if task?.isDone == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskIdentifier = toDoList.tasks[indexPath.row].identifier
            mainViewContentUpdateDelegate?.updateTaskLabel(with: taskIdentifier)
            navigationController?.popViewController(animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let position = indexPath.row
            let id = toDoList.tasks[position].identifier
            
            toDoList.deleteTask(withID: id)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
