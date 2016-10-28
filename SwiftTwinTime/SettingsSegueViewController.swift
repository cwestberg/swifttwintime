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
    var timeUnit = "cents"
    var controlFunction = "regularity"
    
    
    @IBOutlet weak var timeUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var distUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var controlFunctionSegmentedControl: UISegmentedControl!

    
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
        case "regularity":
            controlFunctionSegmentedControl.selectedSegmentIndex = 1
        case "jogularity":
            controlFunctionSegmentedControl.selectedSegmentIndex=2
        case "jogularityTOD":
            controlFunctionSegmentedControl.selectedSegmentIndex=3
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
        case 1:
            controlFunction = "regularity"
        case 2:
            controlFunction = "jogularity"
        case 3:
            controlFunction = "jogularityTOD"
        default:
            break;
        }
    }

}
