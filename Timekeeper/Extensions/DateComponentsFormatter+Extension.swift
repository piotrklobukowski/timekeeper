//
//  DateComponentsFormatter+Extension.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 07/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    
    func clockFormat(from value: TimeInterval) -> String? {
        guard let string = self.string(from: value) else { return nil }
        let substrings = string.split(separator: ":")
        var clockFormatParts = [String]()

        for substring in substrings {
            if substring.count == 1 {
                let element = "0" + substring
                clockFormatParts.append(element)
            } else {
                clockFormatParts.append(String(substring))
            }
        }
        
        return clockFormatParts.joined(separator: ":")
    }
}
