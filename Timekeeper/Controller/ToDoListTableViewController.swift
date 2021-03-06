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
    
    weak var mainViewContentUpdateDelegate: MainViewContentUpdateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = String.toDoListTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertForTaskAdding))
        navigationController?.delegate = self
        
        setupToDoList()
        toDoList?.loadToDoList()
    }
    
    fileprivate func setupToDoList() {
        if toDoList == nil {
            toDoList = ToDoList()
        }
    }
    
    @objc func showAlertForTaskAdding() {
        let ac = UIAlertController(title: String.addTask, message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: String.add, style: .default) {
            [weak self, weak ac] _ in
            
            guard let taskDescription = ac?.textFields?[0].text else { return }
            
            self?.toDoList?.addTask(description: taskDescription)
            guard let row = self?.toDoList?.tasks.count else { return }
            
            let indexPath = IndexPath(row: row - 1, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            
        })
        ac.addAction(UIAlertAction(title: String.cancel, style: .cancel))
        present(ac, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = toDoList?.tasks.count else { return 0 }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String.StoryboardIdentifiers.toDoListCell.rawValue, for: indexPath)
        guard let task = toDoList?.tasks[indexPath.row] else { return cell }
        
        cell.accessibilityIdentifier = "TaskCell_\(indexPath.row)"
        cell.textLabel?.text = task.descriptionOfTask
        cell.accessoryType = task.isDone ? .checkmark : .none
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskIdentifier = toDoList?.tasks[indexPath.row].identifier else { return }
            mainViewContentUpdateDelegate?.updateTaskLabel(with: taskIdentifier)
            navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let position = indexPath.row
            guard let id = toDoList?.tasks[position].identifier else { return }
            
            toDoList?.deleteTask(withID: id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ToDoListTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let mainVC = viewController as? MainViewController else { return }
        if toDoList?.searchForTask(idNumber: mainVC.taskIdentifier) == nil {
            mainViewContentUpdateDelegate?.updateTaskLabel(with: 0)
        }
    }
}
