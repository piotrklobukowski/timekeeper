//
//  MainViewContentUpdateDelegate.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 16/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

protocol MainViewContentUpdateDelegate: AnyObject {
    func updateTaskLabel(with taskID: Int64)
    func updateMainVCwithSettings()
}
