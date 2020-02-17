//
//  ToDoList.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 16/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct ToDoList {
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext) {
        self.context = context
    }
    
    let context: NSManagedObjectContext
    var tasks = [Task]()
    
    mutating func addTask(description: String) {
        let task = Task(context: context)
        task.identifier = Int64(UUID().hashValue)
        task.descriptionOfTask = description
        task.isDone = false
        tasks.append(task)
        saveToDoList()
    }
    
    mutating func deleteTask(withID id: Int64) {
        guard let position = searchForTask(idNumber: id) else { return }

        context.delete(tasks[position])
        tasks.remove(at: position)
        saveToDoList()
    }
    
    mutating func taskIsDone(id: Int64) {
        let position = searchForTask(idNumber: id)
        guard let unwrappedPosition = position else { return }
        tasks[unwrappedPosition].isDone = true
        saveToDoList()
    }
    
    func searchForTask(idNumber: Int64) -> Array<Task>.Index? {
        let number = tasks.index() { Task in
            Task.identifier == idNumber
        }
        guard let numberOfIndex = number else { return number }
        return numberOfIndex
    }
    
    // MARK: - Model Manipulation Methods
    
    func saveToDoList() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    mutating func loadToDoList() {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
    }
}
