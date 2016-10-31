//
//  SettingsSegueViewController.swift
//  SwiftTwinTime
//
//  Created by Clarence Westberg on 10/26/16.
//  Copyright © 2016 Clarence Westberg. All rights reserved.
//

import UIKit

class SettingsSegueViewController: UIViewController {
    var distUnit = "miles"
    var timeUnit = "seconds"
    var controlFunction = "regularity"
    
    
    @IBOutlet weak var timeUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var distUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var controlFunctionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var helpTextView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch timeUnit
        {
        case "seconds":
            self.timeUnitSegmentedControl.selectedSegmentIndex=0
        case "cents":
            self.timeUnitSegmentedControl.selectedSegmentIndex=1
        default:
            break;
        }
        switch controlFunction {
        case "basic":
            controlFunctionSegmentedControl.selectedSegmentIndex=0
            basicText()
        case "regularity":
            controlFunctionSegmentedControl.selectedSegmentIndex = 1
            regularityText()
        case "jogularity":
            jogularityText()
            controlFunctionSegmentedControl.selectedSegmentIndex=2
        case "jogularityTOD":
            controlFunctionSegmentedControl.selectedSegmentIndex=3
            jogularityTODText()
        case "jogularityN":
            controlFunctionSegmentedControl.selectedSegmentIndex=4
            jogularityNText()
        case "regularityN":
            controlFunctionSegmentedControl.selectedSegmentIndex=5
            regularityNText()
        default:
            break
        }
        switch distUnit {
        case "miles":
            distUnitSegmentedControl.selectedSegmentIndex=0
        case "km":
            distUnitSegmentedControl.selectedSegmentIndex=1
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func timeUnitChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            timeUnit = "seconds"
        case 1:
            timeUnit = "cents"
        default:
            print("timeUnit error")
            break;
        }
    }
    
    @IBAction func distUnitChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            distUnit = "miles"
        case 1:
            distUnit = "km"
        default:
            break;
        }
    }

    @IBAction func controlFunctionChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            controlFunction = "basic"
            basicText()
        case 1:
            controlFunction = "regularity"
            regularityText()
        case 2:
            controlFunction = "jogularity"
            jogularityText()
        case 3:
            controlFunction = "jogularityTOD"
            jogularityTODText()
        case 4:
            controlFunction = "jogularityN"
            jogularityNText()
        case 5:
            controlFunction = "regularityN"
            regularityNText()
        default:
            break;
        }
    }
    func basicText() {
        helpTextView.text = "Basic"
    }
    func regularityText() {
        helpTextView.text = "Zero IM zeros OM, \nZeros Timer and \nStarts timer\nControl button records IM and Timer\nZeros IM and\nZeros Timer"
    }
    func regularityNText() {
        helpTextView.text = "Zero IM zeros OM, \nZeros Timer and \nStarts timer at the next minute\nControl button records IM and Timer\nZeros IM and\nZeros Timer"
    }
    func jogularityNText() {
        helpTextView.text = "Zero IM zeros OM, \nZeros Timer and \nStarts timer at the next minute\nControl button records IM and Timer\nTimer and IM are left alone"
    }
    func jogularityText() {
        helpTextView.text = "Zero IM zeros OM, \nZeros Timer and \nStarts timer\nControl button records IM and Timer\nTimer and IM are left alone"
    }
    func jogularityTODText() {
        helpTextView.text = "Zero IM zeros OM, \nTimer is left alone\nControl button records IM and TOD\nTimer and IM are left alone"
    }

}
