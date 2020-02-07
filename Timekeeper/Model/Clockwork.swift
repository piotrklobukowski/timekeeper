//
//  Clockwork.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 03/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

//class Clockwork {
//    
//    var timer: DispatchSourceTimer?
//    
//    func createTimer() {
//        timer = DispatchSource.makeTimerSource(queue: .main)
//        timer?.schedule(deadline: .now(), repeating: 0.1)
//        
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .positional
//        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
//        formatter.zeroFormattingBehavior = .pad
//        
//        timer?.setEventHandler { [weak self] in
//            guard let start = self?.start else { return }
//            let elapsed = (self?.totalElapsed ?? 0) + CACurrentMediaTime() - start
//            self?.label.text = formatter.string(from: elapsed)
//        }
//    }
//    
//    var start: CFTimeInterval?         // if nil, timer not running
//    var totalElapsed: CFTimeInterval?
//    
//    @objc func didTapButton(_ button: UIButton) {
//        if start == nil {
//            startTimer()
//        } else {
//            pauseTimer()
//        }
//    }
//    
//    private func startTimer() {
//        start = CACurrentMediaTime()
//        timer?.resume()
//    }
//    
//    private func pauseTimer() {
//        timer?.suspend()
//        totalElapsed = (totalElapsed ?? 0) + (CACurrentMediaTime() - start!)
//        start = nil
//    }
//    
//}
