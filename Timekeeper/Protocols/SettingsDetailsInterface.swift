//
//  SettingsDetailsInterface.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 09/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

protocol SettingsDetailsInterface {
    var detailsType: SettingsDetailsType? { get set }
    var settings: Settings? { get set }
    var delegate: SettingsUpdateDelegate? { get set }
}
