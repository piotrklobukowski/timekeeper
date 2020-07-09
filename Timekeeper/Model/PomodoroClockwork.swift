//
//  Clockwork.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 03/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class PomodoroClockwork {

    private let clock = Clock()
    
    private (set) var settings: ClockSettings
    private (set) var currentPhase: PomodoroPhases
    private var shortBreaksElapsed: Int = 0
    
    weak var delegate: PomodoroClockworkDelegate?
    
    init(settings: ClockSettings, startingPhase: PomodoroPhases = .work) {
        self.settings = settings
        self.currentPhase = startingPhase
        self.clock.delegate = self
    }
    
    var currentPhaseTime: String {
        return clock.currentTimeText ?? "00:00"
    }
    
    func start() {
        clock.startTimer()
    }
    
    func pause() {
        clock.pauseTimer()
    }
    
    func terminate() {
        clock.terminateTimer()
        currentPhase = .work
        shortBreaksElapsed = 0
        delegate?.resetDataForClockworkRepresentation(numberOfShortBreaks: shortBreaksElapsed)
    }
    
    private func resetClock() {
        clock.terminateTimer()
        clock.startTimer()
    }
 
}

extension PomodoroClockwork: ClockDelegate {
    
    func timeDidChange() {
        guard let ct = clock.currentTime else { return }
        let currentTime = ct.rounded(.down)
        delegate?.updateTimeInClockworkLabel(currentTime: currentTime, phase: currentPhase)
        switch currentPhase {
        case .work:
            guard currentTime >= settings.workTimeDuration else { return }
            if shortBreaksElapsed >= settings.shortBreaksCount {
                currentPhase = .longBreak
                delegate?.changeBreakInformationLabel(phase: .longBreak, numberOfShortBreaks: nil)
                resetClock()
            } else {
                currentPhase = .shortBreak
                delegate?.changeBreakInformationLabel(phase: .shortBreak, numberOfShortBreaks: nil)
                resetClock()
            }
        case .shortBreak:
            if currentTime >= settings.shortBreakDuration {
                currentPhase = .work
                shortBreaksElapsed += 1
                delegate?.changeBreakInformationLabel(phase: .work, numberOfShortBreaks: shortBreaksElapsed)
                resetClock()
            }
        case .longBreak:
            if currentTime >= settings.longBreakDuration {
                currentPhase = .work
                shortBreaksElapsed = 0
                delegate?.changeBreakInformationLabel(phase: .work, numberOfShortBreaks: shortBreaksElapsed)
                resetClock()
            }
        }
    }
}

enum PomodoroPhases {
    case work
    case shortBreak
    case longBreak
}
