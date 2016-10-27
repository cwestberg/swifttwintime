//
//  ViewController.swift
//  SwiftTwinTime
//
//  Created by Clarence Westberg on 10/21/16.
//  Copyright © 2016 Clarence Westberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var todLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stepperControl: UIStepper!
    @IBOutlet weak var stepperFunctionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    
    // Variables
    var tod = NSDate()
    var timer = Timer()
    var timerCounter = 0
    var items: [String] = []
    var timeUnit = "seconds"
    var distUnit = "miles"
    var timeAdjustStepperValue = 0.0
    var factorStepperValue = 0.0
    var currentStepperValue = 0.0
    var currentStepperMinValue = 0.0
    var currentStepperMaxValue = 999.00
    var currentStepValue = 0.01
    var rallyTime = RallyTime(timeUnitString: "seconds")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTimersForUnit()

//        // Do any additional setup after loading the view, typically from a nib.
//       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
    }
    
    @IBAction func stepperFuctionSegmentedControl(_ sender: UISegmentedControl) {
    }
    
    @IBAction func secondsOrCents(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            timeUnit = "seconds"
        case 1:
            timeUnit = "cents"
        default:
            break;
        }
        rallyTime.timeUnit = timeUnit
//        splitBtn(sender: self)
    }
    // Moves all time functionality to RallyTime
    func updateTime() {
        rallyTime.updateTime()
        todLabel.text = rallyTime.todLabel
        timerLabel.text = rallyTime.timerLabel
    }
    
    @IBAction func startTimerBtn(_ sender: Any) {
//        timer.invalidate()

        rallyTime.startTimer()
//        timerCounter = 0
//        timer.invalidate()
//        timerLabel.text = "00 00"
//        // 0.6 for cents
//        // 1.0 for seconds
//        var timeInterval = 0.6
//        if timeUnit == "seconds" {
//            timeInterval = 1.0
//        }
//
//        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector( updateTimerLabel), userInfo: nil, repeats: true)
       
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue \(segue.identifier)")
        if let settingsVC = segue.destination as? SettingsSegueViewController{
            settingsVC.timeUnit = self.timeUnit
        }

    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        let model = sender.source as! SettingsSegueViewController
        print("segue unwind \(model.timeUnit) ")
        timeUnit = model.timeUnit
        rallyTime.timeUnit = timeUnit
        rallyTime = RallyTime(timeUnitString: timeUnit)

        self.setupTimersForUnit()


        print("segue unwind \(model.distUnit) ")
        print("segue unwind \(model.controlFunction) ")

    }
//    @IBAction func saveToViewController(sender: UIStoryboardSegue) {
//        print("segue save \(sender.source.isKind(of: SettingsSegueViewController.self))")
//        sender.source.isKind(of: SettingsSegueViewController.self)
//        
//    }
//    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        print("segue unwind \(unwindSegue.identifier)")
//    }
    
    //    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        print("unwind")
//    }
    
    func setupTimersForUnit() {
        timer.invalidate()
        var timeInterval = 0.6
        if timeUnit == "seconds" {
            timeInterval = 1.0
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self,
                                 selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    
    
    // Deprecate
    func updateTimerLabel() {
        timerCounter += 1
        let ti = timerCounter
        print("timer \(ti)")
        if timeUnit == "seconds" {
            let seconds = String(format: "%0.2d",ti % 60)
            let m = (ti / 60) % 60
            let minutes = String(format: "%0.2d",m)
            //        let hours = (ti / 3600)
            timerLabel.text = "\(minutes):\(seconds)"
        }
        else {
            let cents = String(format: "%0.2d",ti % 100)
            let m = (ti / 60) % 100
            let minutes = String(format: "%0.2d",m)
            //        let hours = (ti / 3600)
            timerLabel.text = "\(minutes).\(cents)"
        }

    }
    
    func updateTimeLabel() {
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
            todLabel.text = "\(dateComponents.hour!):\(minuteString):\(secondString)"
        case "cents":
            todLabel.text = "\(dateComponents.hour!):\(minuteString).\(centString)"
        default:
            break
        }
    }

}

