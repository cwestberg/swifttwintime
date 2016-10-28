//
//  CoreLocationController.swift
//  SwiftTwinTime
//
//  Created by Clarence Westberg on 10/24/16.
//  Copyright © 2016 Clarence Westberg. All rights reserved.
//


import Foundation
import CoreLocation

class CoreLocationController: NSObject, CLLocationManagerDelegate{
    var locationManager:CLLocationManager = CLLocationManager()
    var fromLocation = [CLLocation]()
    var currentLocations = [CLLocation]()
    var miles = 0.00
    var imMiles = 0.00
    var km = 0.00
    var meters = 0.00
    var imMeters = 0.00
    var imKM = 0.00
    var factor = 1.0000
    var direction = "forward"
    var selectedCounters = "om"
    //    var xgpsConnected = false
    
    var startTime = Date()
    override init() {
        self.miles = 0.0
        self.factor = 1.0
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.reset(_:)), name: NSNotification.Name(rawValue: "Reset"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.resetIM(_:)), name: NSNotification.Name(rawValue: "ResetIM") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.resetBoth(_:)), name: NSNotification.Name(rawValue: "ResetBoth") , object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("zeroIntervalTime:"), name: "ZeroInterval", object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.factorChanged(_:)), name: NSNotification.Name(rawValue: "FACTOR_CHANGED") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.plusOne(_:)), name: NSNotification.Name(rawValue: "PlusOne") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.minusOne(_:)), name: NSNotification.Name(rawValue: "MinusOne") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.directionChanged(_:)), name: NSNotification.Name(rawValue: "DirectionChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.selectedCountersChanged(_:)), name: NSNotification.Name(rawValue: "SelectedCountersChanged") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.splitOM(_:)), name: NSNotification.Name(rawValue: "SplitOM") , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CoreLocationController.setMileage(_:)), name: NSNotification.Name(rawValue: "SetMileage") , object: nil)
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            self.locationManager.requestAlwaysAuthorization()

            break
            
        case .authorizedAlways:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
            //            fromLocation = self.locationManager.location!
            //    self.fromLocation = CLLocation()
            break
            
        case .denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    
    
    //    @objc(locationManager:didUpdateLocations:)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        //        print("xgpsConnected \(xgpsConnected)")
        //        if xgpsConnected == false {
        updateLocation(locations,xgps: false)
        //        }
    }
    
    func updateLocation(_ locations: [CLLocation],xgps: Bool) {
        //        return
        var prevLocation: CLLocation
        if self.fromLocation.count == 0 {
            self.fromLocation = locations
            prevLocation = locations.first!
        }
        else {
            prevLocation = self.fromLocation.last!
        }
        
        for location in locations {
            //            print("location \(location)")
            
            //            if self.fromLocation.count > 0 {
            //            if 1 == 1 {
            var addDistance = true
            //                let location:CLLocation = locations.last!
            if xgps == true {
                
            }
            else {
                if location.speed < 1 {
                    addDistance = false
                }
                //print("horizontalAccuracy: \(location.horizontalAccuracy)")
                if location.horizontalAccuracy > 40 || location.horizontalAccuracy < 0 {
                    //print("return: \(location.horizontalAccuracy), \(location.speed)")
                    addDistance = false
                }
                if abs(location.horizontalAccuracy - prevLocation.horizontalAccuracy) > 20 {
                    //print("abs > 20")
                    addDistance = false
                }
                if prevLocation.speed < 0 {
                    addDistance = false
                }
                if location.timestamp.timeIntervalSinceReferenceDate < prevLocation.timestamp.timeIntervalSinceReferenceDate {
                    addDistance = false
                }
            }
            if addDistance == true {
                
                let distance = location.distance(from: prevLocation)
                let updateChoices = (self.direction, self.selectedCounters)
                switch updateChoices
                {
                case ("forward","both"):
                    self.meters += distance // Actually meters
                    self.imMeters += distance // Actually meters
                case ("forward","om"):
                    self.meters += distance // Actually meters
                case ("forward","im"):
                    self.imMeters += distance // Actually meters
                case ("reverse","both"):
                    self.meters -= distance // Actually meters
                    self.imMeters -= distance // Actually meters
                case ("reverse","om"):
                    self.meters -= distance // Actually meters
                case ("reverse","im"):
                    self.imMeters -= distance // Actually meters
                default:
                    break;
                }
                if self.meters < 0.0 {
                    self.meters = 0.0
                }
                if self.imMeters < 0.0 {
                    self.imMeters = 0.0
                }
                self.km = (self.meters/1000) * self.factor
                let distanceInMiles:Float64 = ((self.meters * 0.000621371) * self.factor)
                self.miles = distanceInMiles
                let imDdistanceInMiles:Float64 = ((self.imMeters * 0.000621371) * self.factor)
                self.imMiles = imDdistanceInMiles
                self.imKM = (imMeters/1000) * self.factor
            }
            
            let elapsedTime = Date().timeIntervalSince(self.startTime)
            var averageSpeed = 3600 * (miles/(elapsedTime))
            if averageSpeed > 100 {
                averageSpeed = 100
            }
            let userInfo = [
                "miles":self.miles,
                "imMiles":self.imMiles,
                "imKM":self.imKM,
                "km":self.km,
                "speed":Int(location.speed * 2.23694),
                "latitude":location.coordinate.latitude,
                "longitude":location.coordinate.longitude,
                "horizontalAccuracy":location.horizontalAccuracy,
                "averageSpeed":averageSpeed,
                "et":elapsedTime] as [String : Any]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATION_AVAILABLE"), object: nil, userInfo: userInfo as [NSObject : AnyObject])
            prevLocation = location
            //            }
        }
        self.currentLocations = locations
        self.fromLocation = locations
    }
    
    func splitOM(_ notification:Notification) -> Void {
        guard let _ = self.fromLocation.last
            else {
                let userInfo = [
                    "timestamp":Date(),
                    "course":0.0,
                    "miles":miles,
                    "imMiles":self.imMiles,
                    "km":self.km,
                    "imKM": self.imKM,
                    "speed":45,
                    "latitude":44.875328,
                    "longitude": -91.939003,
                    "horizontalAccuracy":5] as [String : Any]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "Split"), object: nil, userInfo: userInfo as [NSObject : AnyObject])
                return
        }
        let userInfo = [
            "miles": self.miles,
            "imMiles":self.imMiles,
            "imKM":self.imKM,
            "km":self.km,
            "speed":Int(self.fromLocation.last!.speed * 2.23694),
            "latitude":self.fromLocation.last!.coordinate.latitude,
            "longitude":self.fromLocation.last!.coordinate.longitude,
            "horizontalAccuracy":self.fromLocation.last!.horizontalAccuracy] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Split"), object: nil, userInfo: userInfo as [NSObject : AnyObject])
    }
    
    
    func selectedCountersChanged(_ notification:Notification) -> Void {
        //        print("selectedCountersChanged")
        let userInfo = (notification as NSNotification).userInfo
        let ctrs = userInfo!["action"]!
        self.selectedCounters = ctrs as! String
    }
    
    func directionChanged(_ notification:Notification) -> Void {
        //        print("change direction")
        let userInfo = (notification as NSNotification).userInfo
        let newDirection = userInfo!["action"]!
        self.direction = newDirection as! String
    }
    
    func reset(_ notification:Notification) -> Void {
        //        let userInfo = notification.userInfo
        //        print("reset notification: \(userInfo))")
        self.meters = 0.00
        self.km = 0.00
        self.miles = 0.000
        dummyLocationNotification()
    }
    
    func resetIM(_ notification:Notification) -> Void {
        self.imMeters = 0.00
        self.imMiles = 0.000
        self.imKM = 0.0
        dummyLocationNotification()
        
    }
    
    func resetBoth(_ notification:Notification) -> Void {
        self.meters = 0.00
        self.miles = 0.000
        self.imMeters = 0.00
        self.imMiles = 0.000
        self.imKM = 0.0
        self.km = 0.0
        dummyLocationNotification()
        
    }
    
    
    func factorChanged(_ notification:Notification) -> Void {
        let userInfo = (notification as NSNotification).userInfo
        let newFactor = userInfo!["factor"]!
        //        print("ChangeFactor Notification: \(newFactor) \(self.meters)")
        self.factor = newFactor as! Float64
        let distanceInMiles:Float64 = ((self.meters * 0.000621371) * self.factor)
        self.miles = distanceInMiles
        let distanceInMeters:Float64 = ((self.imMeters * 0.000621371))
        self.imMiles = distanceInMeters
        self.km = (self.meters/1000) * self.factor
        self.makeLocationNotification()
    }
    
    func dummyLocationNotification() {
        print("dummy")
        
        let distanceInMiles:Float64 = ((self.meters * 0.000621371))
        self.miles = distanceInMiles * self.factor
        let distanceInMeters:Float64 = ((self.imMeters * 0.000621371))
        self.imMiles = distanceInMeters
        self.km = (self.meters/1000)
        self.imKM = (self.imMeters/1000)
        
        let userInfo = [
            "timestamp":Date(),
            "course":0.0,
            "miles":miles,
            "imMiles":self.imMiles,
            "km":self.km,
            "imKM": self.imKM,
            "speed":45,
            "latitude":44.875328,
            "longitude": -91.939003,
            "horizontalAccuracy":5] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATION_AVAILABLE"), object: nil, userInfo: userInfo as [NSObject : AnyObject])
    }
    
    func plusOne(_ notification:Notification) -> Void {
        //        guard let _ = self.fromLocation.last
        //            else {
        //                return
        //        }
        
        let updateChoices = self.selectedCounters
        
        switch updateChoices
        {
        case "both":
            self.meters += (0.01/0.00062137)
            self.imMeters += (0.01/0.00062137)
        case "om":
            self.meters += (0.01/0.00062137)
        case "im":
            self.imMeters += (0.01/0.00062137)
        default:
            break;
        }
        
        guard let _ = self.fromLocation.last
            else {
                self.dummyLocationNotification()
                return
        }
        
        let distanceInMiles:Float64 = ((self.meters * 0.000621371)) * self.factor
        self.miles = distanceInMiles
        let distanceInMeters:Float64 = ((self.imMeters * 0.000621371)) * self.factor
        self.imMiles = distanceInMeters
        self.km = (self.meters/1000)
        self.imKM = (self.imMeters/1000)
        
        let userInfo = [
            "miles":miles,
            "imMiles":self.imMiles,
            "km":self.km,
            "imKM": self.imKM,
            "speed":Int(self.fromLocation.last!.speed * 2.23694),
            "latitude":self.fromLocation.last!.coordinate.latitude,
            "longitude":self.fromLocation.last!.coordinate.longitude,
            "horizontalAccuracy":self.fromLocation.last!.horizontalAccuracy] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATION_AVAILABLE"), object: nil, userInfo: userInfo as [NSObject : AnyObject])
    }
    
    func minusOne(_ notification:Notification) -> Void {
        //        guard let _ = self.fromLocation.last
        //            else {
        //                return
        //        }
        let updateChoices = self.selectedCounters
        
        switch updateChoices
        {
        case "both":
            self.meters -= (0.01/0.00062137)
            self.imMeters -= (0.01/0.00062137)
        case "om":
            self.meters -= (0.01/0.00062137)
        case "im":
            self.imMeters -= (0.01/0.00062137)
        default:
            break;
        }
        
        if self.meters < 0.0 {
            self.meters = 0.0
        }
        if self.imMeters < 0.0 {
            self.imMeters = 0.0
        }
        
        guard let _ = self.fromLocation.last
            else {
                self.dummyLocationNotification()
                return
        }
        
        let distanceInMiles:Float64 = ((self.meters * 0.000621371)) * self.factor
        self.miles = distanceInMiles
        let distanceInMeters:Float64 = ((self.imMeters * 0.000621371)) * self.factor
        self.imMiles = distanceInMeters
        self.imKM = (self.imMeters/1000)
        
        let userInfo = [
            "miles":miles,
            "imMiles":self.imMiles,
            "km":self.km,
            "imKM": self.imKM,
            "speed":Int(self.fromLocation.last!.speed * 2.23694),
            "latitude":self.fromLocation.last!.coordinate.latitude,
            "longitude":self.fromLocation.last!.coordinate.longitude,
            "horizontalAccuracy":self.fromLocation.last!.horizontalAccuracy] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATION_AVAILABLE"), object: nil, userInfo: userInfo as [NSObject : AnyObject])
    }
    
    
    func setMileage(_ notification:Notification) -> Void {
        var userInfo = (notification as NSNotification).userInfo
        //        print("setMileage notification: \(userInfo))")
        let newMileage = userInfo!["newMileage"] as! Double
        let newMilesAsKM = newMileage * 1.60934
        self.meters = newMilesAsKM * 1000.0
        let distanceInMiles:Float64 = ((self.meters * 0.000621371)) * self.factor
        self.miles = distanceInMiles
        let distanceInMeters:Float64 = ((self.imMeters * 0.000621371)) * self.factor
        self.imMiles = distanceInMeters
        self.imKM = (self.imMeters/1000)
        
        userInfo!["km"] = self.meters
        userInfo!["miles"] = self.miles
        userInfo!["imMiles"] = self.imMiles
        userInfo!["imKM"] = self.imKM
        userInfo!["horizontalAccuracy"] = 5  //Fake
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATION_AVAILABLE"), object: nil, userInfo: userInfo! as [NSObject : AnyObject])
    }
    
    func makeLocationNotification() -> Void {
        guard let _ = self.currentLocations.last
            else {
                return
        }
        let userInfo = [
            "km":self.meters,
            "miles":self.miles,
            "imMiles":self.imMiles,
            "imKM": self.imKM,
            "speed":Int(self.currentLocations.last!.speed * 2.23694),
            "latitude":self.currentLocations.last!.coordinate.latitude,
            "longitude":self.currentLocations.last!.coordinate.longitude,
            "horizontalAccuracy":self.currentLocations.last!.horizontalAccuracy] as [String : Any]
        //        print("makeLocationNotification \(userInfo))")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LOCATION_AVAILABLE"), object: nil, userInfo: userInfo as [NSObject : AnyObject])
    }
    
}
