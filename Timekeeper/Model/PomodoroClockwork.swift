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
    private let settings: ClockSettings
    
    private (set) var currentPhase: PomodoroPhases
    private var shortBreaksElapsed: Int = 0
    
    var currentPhaseTime: String? {
        return clock.currentTimeText
    }
    
    init(settings: ClockSettings, startingPhase: PomodoroPhases = .work) {
        self.settings = settings
        self.currentPhase = startingPhase
        self.clock.delegate = self
    }
    
    func start() {
        clock.startTimer()
    }
    
    func pause() {
        clock.pauseTimer()
    }
    
    func resume() {
        clock.startTimer()
    }
    
    private func resetClock() {
        clock.terminateTimer()
        clock.startTimer()
    }
 
}

extension PomodoroClockwork: ClockDelegate {
    
    func timeDidChange() {
        guard let currentTime = clock.currentTime else { return }
        switch currentPhase {
        case .work:
            guard currentTime >= settings.workTimeDuration else { return }
            if shortBreaksElapsed >= settings.shortBreaksCount {
                currentPhase = .longBreak
                resetClock()
            } else {
                currentPhase = .shortBreak
                resetClock()
            }
        case .shortBreak:
            if currentTime >= settings.shortBreakDuration {
                currentPhase = .work
                shortBreaksElapsed += 1
                resetClock()
            }
        case .longBreak:
            if currentTime >= settings.longBreakDuration {
                currentPhase = .work
                shortBreaksElapsed = 0
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
