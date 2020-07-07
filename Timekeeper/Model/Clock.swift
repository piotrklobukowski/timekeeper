//
//  Clock.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 26/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

protocol ClockDelegate: AnyObject {
    func timeDidChange()
}

class Clock {
    
    weak var delegate: ClockDelegate?
    
    var currentTimeText: String?
    var currentTime: CFTimeInterval?
    
    private var timer: Timer?
    private var startTime: CFTimeInterval?
    private var totalTimeElapsed: CFTimeInterval?

    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    func startTimer() {
        timer = createTimer()
        startTime = CACurrentMediaTime()
        timer?.fire()
    }
    
    func pauseTimer() {
        guard let start = startTime, let createdTimer = timer else { return }
        createdTimer.invalidate()
        totalTimeElapsed = (totalTimeElapsed ?? 0) + (CACurrentMediaTime() - start)
        startTime = nil
    }
    
    func terminateTimer() {
        timer?.invalidate()
        currentTime = nil
        currentTimeText = nil
        totalTimeElapsed = nil
        startTime = nil
    }
    
    private func createTimer() -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in
            guard let start = self?.startTime else { return }
            let elapsed = (self?.totalTimeElapsed ?? 0) + CACurrentMediaTime() - start
            self?.setCurrentTimeValues(with: elapsed)
            self?.delegate?.timeDidChange()
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        timer.tolerance = 0.2
        return timer
    }
    
    private func setCurrentTimeValues(with newValue: CFTimeInterval) {
        currentTime = newValue
        currentTimeText = formatter.clockFormat(from: newValue)
    }
    
}
