//
//  Clockwork.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 03/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class Clockwork {
    
    var progress: Double = 0.0 {
        didSet {
            if progress > 0.98 {
                progress = 1.0
            }
        }
    }
    
    private var timer: DispatchSourceTimer?
    private var start: CFTimeInterval?         // if nil, timer not running
    private var totalElapsed: CFTimeInterval?
    
    private var endTime: Double = 0 {
        willSet {
            if newValue == settings.shortBreakDuration {
                shortBreaksElapsed += 1
                print("shortBreaksElapsed = \(shortBreaksElapsed)")
            } else if newValue == settings.longBreakDuration {
                longBreaksElapsed += 1
                print("longBreaksElapsed = \(longBreaksElapsed)")
            }
        }
    }
    
    private var shortBreaksElapsed: Int = 0
    
    private var longBreaksElapsed: Int = 0 {
        didSet {
            if longBreaksElapsed >= settings.longBreaksLimit {
                longBreaksElapsed = 0
                shortBreaksElapsed = 0
                print("beginning")
            }
        }
    }
    
    private var breakDuration: Double {
        get {
            var value: Double = 0
            if shortBreaksElapsed < settings.shortBreaksLimit {
                value = settings.shortBreakDuration
            } else if longBreaksElapsed < settings.longBreaksLimit {
                value = settings.longBreakDuration
            }
            return value
        }
    }
    
    private var timeElapsed: Double = 0 {
        willSet {
            progress = newValue / (endTime + 0.9)
        }
    }
    
    private var periodsElapsed: Int = 0 {
        willSet {
            if newValue % 2 == 0 {
                endTime = settings.workTimeDuration
                print("workTime")
            } else if newValue % 2 == 1 {
                endTime = breakDuration
                print("breakTime: \(breakDuration)")
            }
        }
    }
    
    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private let settings: ClockSettings
    
    init(settings: ClockSettings) {
        self.settings = settings
        self.endTime = settings.workTimeDuration
    }
    
    func createTimer() {
        
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: 0.1)
        timer?.setEventHandler { [weak self] in
            guard let `self` = self, let start = self.start else { return }
            
            let elapsed = (self.totalElapsed ?? 0) + CACurrentMediaTime() - start
            if elapsed - self.timeElapsed >= 0.1 {
                print(self.formatter.string(from: elapsed)!)
            }
            self.timeElapsed = elapsed
            
            if elapsed >= self.endTime + 0.9 {
                self.pauseTimer()
                self.start = nil
                self.totalElapsed = nil
                self.periodsElapsed += 1
                self.startTimer()
            }
        }
    }
    
    private func startTimer() {
        start = CACurrentMediaTime()
        timer?.resume()
    }
    
    private func pauseTimer() {
        timer?.suspend()
        totalElapsed = (totalElapsed ?? 0) + (CACurrentMediaTime() - start!)
        start = nil
    }
    
    func runTimer() {
        if start == nil {
            startTimer()
        } else {
            pauseTimer()
        }
    }
}
