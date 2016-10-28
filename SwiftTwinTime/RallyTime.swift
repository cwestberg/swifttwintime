//
//  RallyTime.swift
//  SwiftTwinTime
//
//  Created by Clarence Westberg on 10/26/16.
//  Copyright © 2016 Clarence Westberg. All rights reserved.
//

import Foundation

class RallyTime {

    var tod = NSDate()
//    var timer = Timer()
    var timerCounter = 0
    var timeInterval = 1.0
    var timeString = ""
    var timeUnit = ""
    var timerLabel = "00 00"
    var todLabel = ""
    var timerStatus = "stopped"
    
    init(timeUnitString: String) {
        timeUnit = timeUnitString
        timerStatus = "stopped"

    }
    
    func updateTime() {
        tod = NSDate()
        //        let secondsToAdd = (timeAdjustStepper.value * 0.1)
        //        tod = tod.addingTimeInterval(Double(secondsToAdd))
        
        let currentDate = NSDate()
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: currentDate as Date)
        
        let millisecond = Int(Double(dateComponents.nanosecond!)/1000000)
        let mytime = dateComponents.second! * 1000 + millisecond
        let cents = trunc((Double(mytime) * 1.66667)/1000)
        
        let unit = Double(dateComponents.second!)
        let second = Int(unit)
        let secondString = String(format: "%02d", second)
        
        let centString = String(format: "%02d", Int(cents))
        let minuteString = String(format: "%02d", dateComponents.minute!)
        switch timeUnit {
        case "seconds":
            todLabel = "\(dateComponents.hour!):\(minuteString):\(secondString)"
        case "cents":
            todLabel = "\(dateComponents.hour!):\(minuteString).\(centString)"
        default:
            break
        }
        print("second \(second)")
        
        switch timerStatus {
        case "started":
            self.updateTimer()
        case "waiting":
            timerLabel = "waiting"
            if second == 0 {
                timerStatus = "started"
                timerCounter = 0
            }
//        case "stopped":
//            print("stopped")
        default:
            timerStatus = "stopped"
//            print("WTF timer")
        }
    }
    func wait()  {
        timerStatus = "waiting"
    }
    
    func updateTimer() {
        timerCounter += 1
        let ti = timerCounter
        if timeUnit == "seconds" {
            let seconds = String(format: "%0.2d",ti % 60)
            let m = (ti / 60) % 60
            let minutes = String(format: "%0.2d",m)
            //        let hours = (ti / 3600)
            timerLabel = "\(minutes):\(seconds)"
        }
        else {
            let cents = String(format: "%0.2d",ti % 100)
            let m = (ti / 60) % 100
            let minutes = String(format: "%0.2d",m)
            //        let hours = (ti / 3600)
            timerLabel = "\(minutes).\(cents)"
        }
    }
    
    func startTimer() {
        timerCounter = 0
//        timer.invalidate()
        timerLabel = "00 00"
        timerStatus = "started"
    }
}
