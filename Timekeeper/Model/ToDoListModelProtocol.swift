//
//  ToDoListModelProtocol.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 17/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

protocol ToDoListModelProtocol {
    
    mutating func addTask(description: String)
    
    mutating func deleteTask(withID id: Int64)
    
    mutating func taskIsDone(id: Int64)
    
    func searchForTask(idNumber: Int64) -> Array<Task>.Index?
}
