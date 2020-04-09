//
//  PomodoroClockworkDelegate.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 13/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

protocol PomodoroClockworkDelegate: AnyObject {
    func updateTimeInClockworkLabel(currentTime: CFTimeInterval, phase: PomodoroPhases)
    func changeBreakInformationLabel(phase: PomodoroPhases, numberOfShortBreaks: Int?)
    func resetDataForClockworkRepresentation(numberOfShortBreaks: Int)
}
