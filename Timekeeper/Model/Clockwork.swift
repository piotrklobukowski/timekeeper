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
    var timer: DispatchSourceTimer?
    
    let workTimeDuration: Double
    let shortBreakDuration: Double
    let longBreakDuration: Double
    let shortBreaksLimit: Int
    let longBreaksLimit: Int
    
    
    init(workTime: Double, shortBreakDuration: Double, longBreakDuration: Double, shortBreaksLimit: Int, longBreaksLimit: Int) {
        workTimeDuration = workTime
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.shortBreaksLimit = shortBreaksLimit
        self.longBreaksLimit = longBreaksLimit
    }
    
    func createTimer() {
        
        var shortBreaksElapsed: Int = 0
        
        var longBreaksElapsed: Int = 0 {
            didSet {
                if longBreaksElapsed >= longBreaksLimit {
                    longBreaksElapsed = 0
                    shortBreaksElapsed = 0
                    print("beginning")
                }
            }
        }
        
        var breakDuration: Double {
            get {
                var value: Double = 0
                if shortBreaksElapsed < shortBreaksLimit {
                    value = shortBreakDuration
                } else if longBreaksElapsed < longBreaksLimit {
                    value = longBreakDuration
                }
                return value
            }
        }
        
        var endTime: Double = workTimeDuration {
            willSet {
                if newValue == shortBreakDuration {
                    shortBreaksElapsed += 1
                    print("shortBreaksElapsed = \(shortBreaksElapsed)")
                } else if newValue == longBreakDuration {
                    longBreaksElapsed += 1
                    print("longBreaksElapsed = \(longBreaksElapsed)")
                }
            }
        }
        
        var timeElapsed: Double = 0 {
            willSet {
                progress = newValue / (endTime + 0.9)
            }
        }
        
        var periodsElapsed: Int = 0 {
            willSet {
                if newValue % 2 == 0 {
                    endTime = workTimeDuration
                    print("workTime")
                } else if newValue % 2 == 1 {
                    endTime = breakDuration
                    print("breakTime: \(breakDuration)")
                }
            }
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.zeroFormattingBehavior = .pad
        
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: 0.1)
        timer?.setEventHandler { [weak self] in
            guard let start = self?.start else { return }
            
            let elapsed = (self?.totalElapsed ?? 0) + CACurrentMediaTime() - start
            timeElapsed = elapsed
            print(formatter.string(from: elapsed)!)
            //print(self?.progress)
            
            if elapsed >= endTime + 0.9 {
                self?.pauseTimer()
                self?.start = nil
                self?.totalElapsed = nil
                periodsElapsed += 1
                self?.startTimer()
                
            }
            
        }
        
    }
    
    var start: CFTimeInterval?         // if nil, timer not running
    var totalElapsed: CFTimeInterval?
    
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
