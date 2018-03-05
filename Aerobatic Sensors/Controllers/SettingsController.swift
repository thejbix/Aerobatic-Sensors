//
//  SettingsController.swift
//  Aerobatic Sensors
//
//  Created by Jaydon Bixenman on 1/20/18.
//  Copyright © 2018 thejbix. All rights reserved.
//

import UIKit
import CoreMotion
import Darwin

class SettingsController: UIViewController {

    @IBOutlet var lblPitchOffset: UILabel!
    @IBOutlet var lblRollOffset: UILabel!
    @IBOutlet var lblYawOffset: UILabel!
    
    let data = InstrumentData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.setup()
        
        setLabels()
        
        data.startGyros()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Disappeared")
        data.stopGyros()
    }
    
    @IBAction func calibrate(_ sender: UIButton) {
        
        data.calibrate()
        
        setLabels()
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
    
        performSegue(withIdentifier: "SettingsToMain", sender: self)
    
    }
    
    func setLabels() {
        lblPitchOffset.text = String(abs(Int(data.offsets.pitchOffset * 57.2958)))
        lblRollOffset.text = String(abs(Int(data.offsets.rollOffset * 57.2958)))
        lblYawOffset.text = String(abs(Int(data.offsets.yawOffset * 57.2958)))
        
    }
    
    
}
