//
//  GpsData.swift
//  Aerobatic Sensors
//
//  Created by Jaydon  Bixenman on 3/11/18.
//  Copyright © 2018 thejbix. All rights reserved.
//

import Foundation
import CoreLocation

class GpsData: NSObject, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager? = nil
    var lastUpdate:Date! = Date()
    
    var lastLocation: CLLocation? = nil
    
    var timeDifference:Double = 1 // in seconds
    var speed:Double = 0 // miles per hour
    var altitude:Double = 0 // feet
    var rateOfClimb:Double = 0 //feet per minute
    var climbAngle:Double = 0 // degree

    
    override init() {
        super.init()
        
        setLocationManager()
    }
    
    func setLocationManager() {
        locationManager = CLLocationManager()
        if let locationManager = locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func startGettingLocation() {
        if let locationManager = locationManager {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        }
        
    }
    
    func stopGettingLocation() {
        if let locationManager = locationManager {
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        let startDate = lastUpdate
        let endDate = userLocation.timestamp
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([Calendar.Component.second, Calendar.Component.nanosecond], from: startDate!, to: endDate)
        let seconds = Double(dateComponents.second!)
        let nanoSeconds = Double(dateComponents.nanosecond!)
        
        
        
        timeDifference += seconds + (nanoSeconds/1000000000);
        
        speed = metersSecondToMilesHour(speed: userLocation.speed)
        
        
        if timeDifference >= 1.9 {
            let altitudeAfter = metersToFeet(meters: userLocation.altitude)
            
            rateOfClimb = calculateClimbRate(altitudeBefore: altitude, altitudeAfter: altitudeAfter, seconds: timeDifference)
            altitude = altitudeAfter
            
            
            let rateOfClimb_mileshour = feetMinuteToMilesHour(speed: rateOfClimb)
            //print( rateOfClimb_mileshour)
            
            
            
            
            /*if speed < 0 {
             if lastLocation == nil {
             lastLocation = userLocation
             }
             
             let traveledDistance = lastLocation!.distance(from: userLocation)
             let traveledDistanceMiles = traveledDistance * 0.00062137
             
             
             speed = traveledDistance / (seconds * 3600)
             
             }*/
            
            let theta = atan2(rateOfClimb_mileshour, speed)
            climbAngle = theta * 57.2958
            
            
            printAll();
            timeDifference = 0;
        }
        
        lastUpdate = userLocation.timestamp
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func metersToFeet(meters: Double) -> Double {
        return meters*3.28
    }
    
    func feetToMeters(feet: Double) -> Double {
        return feet/3.28
    }
    
    //meters/second to miles/hour
    func metersSecondToMilesHour(speed: Double) -> Double {
        return speed * 2.23694
    }
    
    func feetMinuteToMilesHour(speed: Double) -> Double {
        return speed * 0.0113636
    }
    
    // altitude must be in feet
    func calculateClimbRate(altitudeBefore: Double, altitudeAfter: Double, seconds: Double) -> Double{ //feet per minute
        return (altitudeAfter-altitudeBefore)/(seconds/60)
    }
    
    func printAll() {
        print("GPS Data {")
        print("Time Difference: ", timeDifference)
        print("speed: ", speed)
        print("Altitude: ", altitude)
        print("rateOfClimb: ", rateOfClimb)
        print("climbAngle: ", climbAngle)
        print("}")
    }
    
}
