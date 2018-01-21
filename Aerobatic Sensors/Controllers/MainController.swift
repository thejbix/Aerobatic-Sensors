//
//  GameViewController.swift
//  Aerobatic Sensors
//
//  Created by Jaydon Bixenman on 11/4/17.
//  Copyright © 2017 thejbix. All rights reserved.
//

import UIKit
import SpriteKit


class MainController: UIViewController {

    var scene:InstrumentScene? = nil
    var skView: SKView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = InstrumentScene(size: view.bounds.size)
        skView = view as! SKView
        skView?.showsFPS = true
        skView?.showsNodeCount = true
        skView?.ignoresSiblingOrder = true
        scene?.scaleMode = .resizeFill
        skView?.presentScene(scene)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
   
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        skView?.scene?.willMove(from: skView!)
        performSegue(withIdentifier: "MainToSettings", sender: self)
        
    }
    
}
