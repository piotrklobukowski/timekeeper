//
//  ToDoListTableViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 11/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    var toDoList: ToDoList?
    weak var mainViewContentUpdateDelegate: MainViewContentUpateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertForTaskAdding))
        
        navigationItem.rightBarButtonItem = addTaskButton
        addTaskButton.tintColor = UIColor(red:0.73, green:0.88, blue:0.98, alpha:1.0)
        
        navigationItem.backBarButtonItem?.tintColor = UIColor(red:0.73, green:0.88, blue:0.98, alpha:1.0)
     

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func showAlertForTaskAdding() {
        let ac = UIAlertController(title: "Add task", message: nil, preferredStyle: .alert)
        ac.addTextField()
//        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let numberOfRows = toDoList?.tasks.count {
            return numberOfRows
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task Cell", for: indexPath)
        let task = toDoList?.tasks[indexPath.row]

        cell.textLabel?.text = task?.name
        
        if task?.isDone == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let taskName = toDoList?.tasks[indexPath.row].name {
            mainViewContentUpdateDelegate?.updateTaskLabel(with: taskName)
            navigationController?.popViewController(animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
