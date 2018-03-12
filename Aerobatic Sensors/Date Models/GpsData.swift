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
        //let dateComponents = calendar.components(NSCalendar.Unit.CalendarUnitSecond, fromDate: startDate, toDate: endDate, options: nil)
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: startDate!, to: endDate)
        let seconds = dateComponents.second!
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        print("altitude = \(metersToFeet(meters: userLocation.altitude))")
        print("speed = \(metersSecondToMilesHour(speed: userLocation.speed))")
        print("timeStamp = \(userLocation.timestamp.description)")
        print("Seconds: \(seconds)")
        
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
        return speed*2.23694
    }
    
}
