//
//  InstrumentData.swift
//  Aerobatic Sensors
//
//  Created by Jaydon  Bixenman on 3/4/18.
//  Copyright © 2018 thejbix. All rights reserved.
//

import Foundation
import CoreMotion


class InstrumentData {
    
    //Handles the obtaining of raw data from sensors
     let motion = CMMotionManager()
     var timerGyro:Timer? = nil
     var timerAccel:Timer? = nil
    //multiple values are taken to make data more smooth
    //the average is used
     var x:[Double] = [0,0,0,0,0] //yaw
     var y:[Double] = [0,0,0,0,0,0,0,0,0,0,0,0,0]//pitch  requires more stability
     var z:[Double] = [0,0,0,0,0] //roll
     var grav:[Double] = [0,0,0,0,0]//grav
     var gravDirection:[Double] = [0,0,0]//gravDirection
    
     var offsets = Offsets()
    
    
    func setup() {
        let offsetData = OffsetsHelper.getAll()
        if let offset = offsetData.first {
            offsets = offset
        }
    }
    
    func startGyros() {
        if self.motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 60.0
            self.motion.startGyroUpdates()
            
            // Configure a timer to fetch the gyroscope data.
            // timer will put rotation rates from gyroscope into x , y, z variables
            self.timerGyro = Timer(fire: Date(), interval: (1.0/60.0),
                                   repeats: true, block: { (timer) in
                                    // Get the gyro data.
                                    if let data = self.motion.gyroData {
                                        self.appendAndPop(&self.x,data.rotationRate.x)
                                        self.appendAndPop(&self.y,data.rotationRate.y * -1)
                                        self.appendAndPop(&self.z,data.rotationRate.z)
                                    }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timerGyro!, forMode: .defaultRunLoopMode)
        }
        
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            // timer will put data from accelerometer into grav(total g force in the x direction) and gravDirection(angle is stored in radians);
            self.timerAccel = Timer(fire: Date(), interval: (1.0/60.0),
                                    repeats: true, block: { (timer) in
                                        // Get the accel data.
                                        if let data = self.motion.accelerometerData?.acceleration {
                                            //let gravStrength = Darwin.sqrt((data.x*data.x) + (data.y*data.y) + (data.z*data.z)) * -1
                                            self.appendAndPop(&self.grav,data.x)
                                            self.appendAndPop(&self.gravDirection,atan(data.y/data.x));
                                        }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timerAccel!, forMode: .defaultRunLoopMode)
        }
    }
    
    //Stop sensor data collecting
    func stopGyros() {
        if self.timerGyro != nil {
            self.timerGyro?.invalidate()
            self.timerGyro = nil
            
            self.motion.stopGyroUpdates()
        }
        
        if self.timerAccel != nil {
            self.timerAccel?.invalidate()
            self.timerAccel = nil
            
            self.motion.stopAccelerometerUpdates()
        }
    }
    
    //append value to array and pop the last
    func appendAndPop(_ numbers: inout [Double], _ newValue: Double)
    {
        numbers.insert(newValue, at: 0)
        numbers.popLast()
    }
    
    
    func calibrate() {
        OffsetsHelper.deleteAll()
        offsets = Offsets()
        offsets.pitchOffset = getAverage(y)
        offsets.rollOffset = getAverage(z)
        offsets.yawOffset = getAverage(x)
        OffsetsHelper.add(offset: offsets)
        
    }
    
    //get average of an array of doubles
    func getAverage(_ numbers: [Double]) -> Double
    {
        var i:Int = 0
        var sum:Double = 0
        for number in numbers
        {
            sum += number
            i += 1
        }
        
        return sum/Double(i)
        
    }
    
}
