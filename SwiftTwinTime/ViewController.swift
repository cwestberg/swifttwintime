//
//  ViewController.swift
//  SwiftTwinTime
//
//  Created by Clarence Westberg on 10/21/16.
//  Copyright © 2016 Clarence Westberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var milesLbl: UILabel!
    @IBOutlet weak var imLbl: UILabel!
    @IBOutlet weak var todLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stepperControl: UIStepper!
    @IBOutlet weak var stepperFunctionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var factorLabel: UILabel!
    @IBOutlet weak var modeLbl: UILabel!
    @IBOutlet weak var timeAdjustLbl: UILabel!
    @IBOutlet weak var selectedcOunters: UISegmentedControl!
    
    // Variables
    var distance = 0.0
    var factor = 1.0
    var tod = NSDate()
    var timer = Timer()
    var timerCounter = 0
    var timeUnit = "seconds"
    var distUnit = "miles"
    var oldStepper = 0.0
    var items: [String] = []
    var actions: [String] = []
    var controlFunction = "basic"
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
        modeLbl.text = controlFunction
        selectedcOunters.selectedSegmentIndex = 1
        let userInfo = [
            "action":"both"]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SelectedCountersChanged"), object: nil, userInfo: userInfo)

//        // Do any additional setup after loading the view, typically from a nib.
//       
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.locationAvailable(_:)), name: NSNotification.Name(rawValue: "LOCATION_AVAILABLE"), object: nil)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        switch stepperFunctionSegmentedControl.selectedSegmentIndex {
        case 0: // Distance
            omStepper(sender)
        case 1: // factor
            factorStepper(sender)
        case 2: // Time
            timeStepper(sender)
        default: break
        }
    }
    func timeStepper(_ sender: UIStepper) {
        timeAdjustStepperValue = sender.value
        timeAdjustLbl.text = String(format: "%.4f",self.timeAdjustStepperValue)
        rallyTime.secondsToAdd = timeAdjustStepperValue
    }
    
    @IBAction func stepperFuctionSegmentedControl(_ sender: UISegmentedControl) {
        switch stepperFunctionSegmentedControl.selectedSegmentIndex {
        case 0: // Distance
            stepperControl.stepValue = 0.01
            stepperControl.value = distance
        case 1: // factor
            stepperControl.stepValue = 0.0005
            stepperControl.value = factor
        case 2: // Time
            stepperControl.maximumValue = 5.0
            stepperControl.minimumValue = -5.0
            stepperControl.stepValue = 0.01
            stepperControl.value = timeAdjustStepperValue
            print("\(stepperControl.value) \(timeAdjustStepperValue)")
        default: break
        }

    }
    
    @IBAction func controlBtn(_ sender: Any) {
        switch controlFunction {
        case "basic":
            items.insert("\(milesLbl.text!) \(rallyTime.todLabel)", at:0)
            self.tableView.reloadData()
        case "regularity":
            // Zero IM and Timer
//            items.insert("\(milesLbl.text!) \(imLbl.text!) \(rallyTime.timerLabel)", at:0)
            items.insert("\(imLbl.text!) \(rallyTime.todLabel)", at:0)
            self.tableView.reloadData()
            zeroIM(sender as AnyObject)
            startTimerBtn(sender as AnyObject)
        case "jogularity":
            // Split IM & Timer
//            items.insert("\(milesLbl.text!) \(imLbl.text!) \(rallyTime.timerLabel)", at:0)
            items.insert("\(milesLbl.text!) \(rallyTime.timerLabel)", at:0)
            self.tableView.reloadData()
        case "jogularityTOD":
            // Split IM & Timer
            items.insert("\(imLbl.text!) \(rallyTime.todLabel)", at:0)
            self.tableView.reloadData()
        case "jogularityN":
            // Split IM & Timer
            items.insert("\(imLbl.text!) \(rallyTime.timerLabel)", at:0)
            self.tableView.reloadData()
        case "regularityN":
            // Zero IM and Timer
            if rallyTime.timerStatus == "started" {
                items.insert("\(imLbl.text!) \(rallyTime.timerLabel)", at:0)
                self.tableView.reloadData()
                zeroIM(sender as AnyObject)
                startTimerBtn(sender as AnyObject)
            }
        default:
            break
        }

    }
//    @IBAction func secondsOrCents(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            timeUnit = "seconds"
//        case 1:
//            timeUnit = "cents"
//        default:
//            break;
//        }
//        rallyTime.timeUnit = timeUnit
////        splitBtn(sender: self)
//    }
    
    @IBAction func selectedCountersChanged(_ sender: AnyObject) {
        //        SelectedCountersChanged
        var counters = ""
        switch sender.selectedSegmentIndex
        {
        case 0:
            counters = "om"
        case 1:
            counters = "both"
        case 2:
            counters = "im"
        default:
            break;
        }
        let userInfo = [
            "action":"\(counters)"]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SelectedCountersChanged"), object: nil, userInfo: userInfo)
    }
    @IBAction func direction(_ sender: AnyObject) {
        var direction = ""
        switch sender.selectedSegmentIndex
        {
        case 0:
            print("direction Btn pushed forward")
            direction = "forward"
        case 1:
            print("direction Btn pushed reverse")
            direction = "reverse"
        default:
            break;
        }
        let userInfo = [
            "action":"\(direction)"]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DirectionChanged"), object: nil, userInfo: userInfo)
        
    }
    func omStepper(_ sender: UIStepper) {
        
        if sender.value < oldStepper{
            let userInfo = [
                "action":"minusOne"]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "MinusOne"), object: nil, userInfo: userInfo)
            
        }
        else{
            let userInfo = [
                "action":"plusOne"]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlusOne"), object: nil, userInfo: userInfo)
        }
        oldStepper = sender.value
        
    }
    func factorStepper(_ sender: UIStepper) {
        self.factor = sender.value
        self.factorLabel.text = String(format: "%.4f",self.factor)
        let userInfo = [
            "factor":factor]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "FACTOR_CHANGED"), object: nil, userInfo: userInfo)
        self.items.insert(String(format: "%.4f", factor), at:0)
        self.actions.insert("Step Factor", at:0)
        self.tableView.reloadData()
    }
    


    
    
    @IBAction func zeroOdo(_ sender: AnyObject) {
        //print("reset Btn pushed")
        let userInfo = [
            "action":"reset"]
        let zom = self.milesLbl.text!
        items.insert("Zero OM @\(zom)", at:0)
        actions.insert("Zero OM", at:0)
        self.tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Reset"), object: nil, userInfo: userInfo)
    }
    
    @IBAction func zeroIM(_ sender: AnyObject) {
        //print("zeroIM Btn pushed")
                self.items.insert("ZIM \(imLbl.text!) \(rallyTime.todLabel)", at:0)
                self.tableView.reloadData()
        switch controlFunction {
        case "regularity":
            startTimerBtn(sender as AnyObject)
//            zeroIM(sender as AnyObject)
        case "regularityN":
            rallyTime.wait()
        case "jogularityN":
            rallyTime.wait()
        case "jogularity" :
            startTimerBtn(sender as AnyObject)
        default:
            break
        }
        
        let userInfo = [
            "action":"resetIM"]
        //        let zim = String(format: "%.2f", self.splitOM)
//        let zim = self.imLbl.text!
//        items.insert("Zero IM @\(zim)", at:0)
//        actions.insert("Zero IM", at:0)
//        self.tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ResetIM"), object: nil, userInfo: userInfo)
    }
    
    
    // Moves all time functionality to RallyTime
    func updateTime() {
        rallyTime.updateTime()
        todLabel.text = rallyTime.todLabel
        timerLabel.text = rallyTime.timerLabel
    }
    
    @IBAction func clearLogBtn(_ sender: Any) {
        self.items = []
        self.tableView.reloadData()
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
    
    func locationAvailable(_ notification:Notification) -> Void {
        let userInfo = (notification as NSNotification).userInfo
        //        print("Odometer UserInfo: \(userInfo)")
        //        print(userInfo!["miles"]!)
        //        let m = userInfo!["miles"]!
        //        self.splitOM = m as! Double
        //        self.milesLbl.text = (String(format: "%.2f", m as! Float64))
        //        let im = userInfo!["imMiles"]!
        //        self.splitIM = im as! Double
        //        self.imLbl.text = (String(format: "%.2f", im as! Float64))
        
        switch distUnit
        {
        case "miles":
            let m = userInfo!["miles"]!
            self.distance = m as! Float64
            self.milesLbl.text = (String(format: "%06.3f", m as! Float64))
            let im = userInfo!["imMiles"]!
            self.imLbl.text = (String(format: "%06.2f", im as! Float64))
        case "km":
            let d = userInfo!["km"]!
            self.distance = d as! Float64
            self.milesLbl.text = (String(format: "%06.2f", d as! Float64))
            let imD = userInfo!["imKM"]!
            self.imLbl.text = (String(format: "%06.2f", imD as! Float64))
        default:
            break;
        }
        //        if (delegate?.xgps160!.isConnected)! == false {
        //            horrizontalAccuracy.text = String(describing: userInfo!["horizontalAccuracy"]!)
        //        }
        
    }

    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingsVC = segue.destination as? SettingsSegueViewController{
            settingsVC.timeUnit = self.timeUnit
            settingsVC.controlFunction = self.controlFunction
            settingsVC.distUnit = self.distUnit
        }

    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        let model = sender.source as! SettingsSegueViewController
//        print("segue unwind \(model.timeUnit) \(timeUnit) ")
        if timeUnit != model.timeUnit {
            timeUnit = model.timeUnit
            rallyTime.timeUnit = timeUnit
            rallyTime = RallyTime(timeUnitString: timeUnit)
            self.setupTimersForUnit()

        }

        controlFunction = model.controlFunction
        modeLbl.text = controlFunction
        distUnit = model.distUnit



//        print("segue unwind \(model.distUnit) ")
//        print("segue unwind \(model.controlFunction) ")

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
    
    // start time
    func setupTimersForUnit() {
        timer.invalidate()
        var timeInterval = 0.6
        if timeUnit == "seconds" {
            timeInterval = 1.0
        }
        // Do any additional setup after loading the view, typically from a nib.
        timeInterval = 0.01
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self,
                                 selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        //        print(indexPath.row)
        //        print(self.actions.count)
        //        print(self.actions)
        cell.textLabel?.text = self.items[(indexPath as NSIndexPath).row]
//        cell.detailTextLabel!.text = self.actions[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You selected cell #\((indexPath as NSIndexPath).row)!")
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            items.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    // End Table

    
    // Deprecate =========================================================
//    func updateTimerLabel() {
//        timerCounter += 1
//        let ti = timerCounter
////        print("timer \(ti)")
//        if timeUnit == "seconds" {
//            let seconds = String(format: "%0.2d",ti % 60)
//            let m = (ti / 60) % 60
//            let minutes = String(format: "%0.2d",m)
//            //        let hours = (ti / 3600)
//            timerLabel.text = "\(minutes):\(seconds)"
//        }
//        else {
//            let cents = String(format: "%0.2d",ti % 100)
//            let m = (ti / 60) % 100
//            let minutes = String(format: "%0.2d",m)
//            //        let hours = (ti / 3600)
//            timerLabel.text = "\(minutes).\(cents)"
//        }
//
//    }
//    
//    func updateTimeLabel() {
//        tod = NSDate()
////        let secondsToAdd = (timeAdjustStepper.value * 0.1)
////        tod = tod.addingTimeInterval(Double(secondsToAdd))
//        
//        let currentDate = NSDate()
//        let calendar = Calendar.current
//        
//        let dateComponents = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: currentDate as Date)
//        
//        let millisecond = Int(Double(dateComponents.nanosecond!)/1000000)
//        let mytime = dateComponents.second! * 1000 + millisecond
//        let cents = trunc((Double(mytime) * 1.66667)/1000)
//        
//        let unit = Double(dateComponents.second!)
//        let second = Int(unit)
//        let secondString = String(format: "%02d", second)
//        
//        let centString = String(format: "%02d", Int(cents))
//        let minuteString = String(format: "%02d", dateComponents.minute!)
//        switch timeUnit {
//        case "seconds":
//            todLabel.text = "\(dateComponents.hour!):\(minuteString):\(secondString)"
//        case "cents":
//            todLabel.text = "\(dateComponents.hour!):\(minuteString).\(centString)"
//        default:
//            break
//        }
//    }

}

