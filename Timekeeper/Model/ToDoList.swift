//
//  ToDoList.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 16/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct Task {
    let name: String
    var isDone: Bool = false
    
    init(name: String) {
        self.name = name
    }
}

struct ToDoList {
    var tasks = [Task]()
    
    mutating func addTask(name: String) {
        tasks.append(Task.init(name: name))
    }
    
    mutating func deleteTask(position: Int) {
        tasks.remove(at: position)
    }
    
    mutating func taskIsDone(name: String) {
        let number = tasks.index() { Task in
            Task.name == name
        }
        guard let unwrappedNumber = number else { return }
            tasks[unwrappedNumber].isDone = true
    }
}
