//
//  String+Extension.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 24/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

extension String {
    
    static var timeSixty: [String] {
        return (0..<60).map { String(format: "%02d", $0) }
    }
    
    static var breaksAmount: [String] {
        return (0..<10).map { String($0) }
    }
}
