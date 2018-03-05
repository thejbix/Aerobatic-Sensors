//
//  GameScene.swift
//  Aerobatic Sensors
//
//  Created by Jaydon Bixenman on 11/4/17.
//  Copyright © 2017 thejbix. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import Darwin


class InstrumentScene: SKScene
{
    //radius of the instruments
    let radius:CGFloat = CGFloat(120)
    //readius of two instruments that point toward the direction of gravity
    let partialRadius:CGFloat = CGFloat(90)
    
    
    let data = InstrumentData()
    
    //Shape for each instrument
    var pitchPie:SKShapeNode = SKShapeNode()
    var rollPie:SKShapeNode = SKShapeNode()
    var yawPie:SKShapeNode = SKShapeNode()
    var gravPie:SKShapeNode = SKShapeNode()
    var gravDirectionBottomPie:SKShapeNode = SKShapeNode()
    var gravDirectionTopPie:SKShapeNode = SKShapeNode()
    
    //Variables used by Pitch Rate Instrument
    var lblPitchValue = SKLabelNode()
    var startAnglePitch = CGFloat.pi
    var calibrationVarPitch:CGFloat = 0.0
    var locationPitch:CGPoint = CGPoint.zero
    
    //Variables used by Roll Rate Instrument
    var lblRollValue = SKLabelNode()
    var startAngleRoll = CGFloat.pi * CGFloat(1.0/2.0)
    var calibrationVarRoll:CGFloat = 0.0
    var locationRoll:CGPoint = CGPoint.zero
    
    //Variables used by Yaw Rate Instrument
    var lblYawValue = SKLabelNode()
    var startAngleYaw = CGFloat.pi * CGFloat(1.0/2.0)
    var calibrationVarYaw:CGFloat = 0.0
    var locationYaw:CGPoint = CGPoint.zero
    
    //Variables used by Total G's Instrument
    var lblGravValue = SKLabelNode()
    var startAngleGrav = CGFloat.pi
    var calibrationVarGrav:CGFloat = 0.0
    var locationGrav:CGPoint = CGPoint.zero
    
    //Variables used by Gravity Direction Instrument displayed on bottom of the screen
    var lblGravDirectionBottomValue = SKLabelNode()
    var startAngleGravDirectionBottom = CGFloat.pi * CGFloat(3.0/2.0);
    var calibrationVarGravDirectionBottom:CGFloat = 0.0
    var locationGravDirectionBottom:CGPoint = CGPoint.zero
    
    //Variables used by Gravity Direction Instrument displayed on top of the screen
    var lblGravDirectionTopValue = SKLabelNode()
    var startAngleGravDirectionTop = CGFloat.pi * CGFloat(1.0/2.0);
    var calibrationVarGravDirectionTop:CGFloat = 0.0
    var locationGravDirectionTop:CGPoint = CGPoint.zero
   
    
    //Used in determining label refresh rate
    var lastTime: CFTimeInterval = 0.0
    
    
    
    
    //Start up function
    //sets up graphical shapes for the instruments
    override func didMove(to view: SKView)
    {
        print("InstrumentScene: DidMove")
        
        
        scene?.backgroundColor = SKColor.white
        
        data.setup()
        
        
        //Pitch Pie Set
        locationPitch = CGPoint(x: view.bounds.width*(1.0/4.0),y: view.bounds.height*(3.0/4.0))
        addPieInPosition(pie: &pitchPie, label: &lblPitchValue, location: locationPitch)
        createLabel(location: locationPitch, str: "Pitch Deg/Sec")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(1.0/4.0), str:"30")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(2.0/4.0), str:"20")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(3.0/4.0), str:"10")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(4.0/4.0), str:"0")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(5.0/4.0), str:"10")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(6.0/4.0), str:"20")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(7.0/4.0), str:"30")
        createTextForInstrument(location: locationPitch, angle: CGFloat.pi*(8.0/4.0), str:"40")
        
        
        
        //Roll pie Set
        locationRoll = CGPoint(x: view.bounds.width*(1.0/4.0),y: view.bounds.height*(1.0/4.0))
        addPieInPosition(pie: &rollPie, label: &lblRollValue,location: locationRoll)
        createLabel(location: locationRoll, str: "Roll Deg/Sec")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(1.0/4.0), str:"90")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(2.0/4.0), str:"0")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(3.0/4.0), str:"90")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(4.0/4.0), str:"180")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(5.0/4.0), str:"270")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(6.0/4.0), str:"360")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(7.0/4.0), str:"270")
        createTextForInstrument(location: locationRoll, angle: CGFloat.pi*(8.0/4.0), str:"180")
        
        
        //Yaw pie Set
        locationYaw = CGPoint(x: view.bounds.width*(3.0/4.0),y: view.bounds.height*(1.0/4.0))
        addPieInPosition(pie: &yawPie, label: &lblYawValue, location: locationYaw)
        createLabel(location: locationYaw, str: "Yaw Deg/Sec")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(1.0/4.0), str:"45")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(2.0/4.0), str:"0")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(3.0/4.0), str:"45")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(4.0/4.0), str:"90")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(5.0/4.0), str:"135")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(6.0/4.0), str:"180")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(7.0/4.0), str:"135")
        createTextForInstrument(location: locationYaw, angle: CGFloat.pi*(8.0/4.0), str:"90")
        
        
        //Grav pie Set
        locationGrav = CGPoint(x: view.bounds.width*(3.0/4.0),y: view.bounds.height*(3.0/4.0))
        addPieInPosition(pie: &gravPie, label: &lblGravValue, location: locationGrav)
        createLabel(location: locationGrav, str: "G-Force")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(1.0/4.0), str:"4.5")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(2.0/4.0), str:"3")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(3.0/4.0), str:"1.5")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(4.0/4.0), str:"0")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(5.0/4.0), str:"1.5")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(6.0/4.0), str:"3")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(7.0/4.0), str:"4.5")
        createTextForInstrument(location: locationGrav, angle: CGFloat.pi*(8.0/4.0), str:"6")
        
        
        
        
        //GravDirection
        locationGravDirectionBottom = CGPoint(x: view.bounds.width*(2.0/4.0),y: view.bounds.height*(1.0/6.0))
        addPartialPieInPosition(pie: &gravDirectionBottomPie, label: &lblGravDirectionBottomValue, location: locationGravDirectionBottom, start: CGFloat.pi * CGFloat(1), stop: CGFloat.pi * CGFloat(2))
        
        locationGravDirectionTop = CGPoint(x: view.bounds.width*(2.0/4.0),y: view.bounds.height*(5.0/6.0))
        addPartialPieInPosition(pie: &gravDirectionTopPie, label: &lblGravDirectionTopValue, location: locationGravDirectionTop, start: CGFloat.pi * CGFloat(0), stop: CGFloat.pi * CGFloat(1));
        
        
        
        //Start collecting Data
        data.startGyros()
        
        view.isPaused = false
    
    }
    
    override func willMove(from view: SKView)
    {
        //Stop Collecting Data
        print("InstrumentScene: willmove")
        view.isPaused = true
        data.stopGyros();
    }
    
    
    
    
    
    
    
    
    //Add whole circle instrument to view
    func addPieInPosition(pie: inout SKShapeNode, label: inout SKLabelNode, location: CGPoint)
    {
        let backCircle = SKShapeNode(circleOfRadius: radius)
        backCircle.strokeColor = SKColor.black
        backCircle.fillColor = SKColor.white
        backCircle.lineWidth = 5
        backCircle.position = location
        self.addChild(backCircle)
        
        
        pie = SKShapeNode() // Size of Circle = Radius setting.
        pie.position = location  //touch location passed from touchesBegan.
        pie.name = "pitch"
        pie.lineWidth = 5
        pie.fillColor = SKColor.green
        pie.strokeColor = SKColor.black
        self.addChild(pie)
        
        
        let labelBackground = SKShapeNode(circleOfRadius: 40)
        labelBackground.fillColor = SKColor.lightGray
        labelBackground.position = location
        labelBackground.strokeColor = SKColor.clear
        self.addChild(labelBackground)
        
        label.text = "20"
        label.fontSize = 45
        label.fontColor = SKColor.black
        label.position = location
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.fontName = "AvenirNext-Bold"
        self.addChild(label)
        
        createLine(location: location, angle: CGFloat.pi * (0.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (1.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (2.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (3.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (4.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (5.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (6.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (7.0/4.0))
        
        
    }
    
    //Add partial circle sensor to the view
    func addPartialPieInPosition(pie: inout SKShapeNode, label: inout SKLabelNode, location: CGPoint, start: CGFloat, stop: CGFloat)
    {
        
        let backCirclePath = CGMutablePath()
        backCirclePath.move(to: CGPoint.zero)
        backCirclePath.addArc(center: CGPoint.zero, radius: partialRadius, startAngle: start, endAngle: stop, clockwise: false);
        backCirclePath.addLine(to: CGPoint.zero)
        backCirclePath.closeSubpath()
        
        
        let backCircle = SKShapeNode(path: backCirclePath);
        backCircle.position = location;
        backCircle.lineWidth = 5;
        backCircle.strokeColor = SKColor.black;
        self.addChild(backCircle);
        
        pie = SKShapeNode() // Size of Circle = Radius setting.
        pie.position = location  //touch location passed from touchesBegan.
        pie.name = "pitch"
        pie.lineWidth = 5
        pie.fillColor = SKColor.green
        pie.strokeColor = SKColor.black
        self.addChild(pie)
        
        
        /*let labelBackground = SKShapeNode(circleOfRadius: 40)
        labelBackground.fillColor = SKColor.lightGray
        labelBackground.position = location
        labelBackground.strokeColor = SKColor.clear
        self.addChild(labelBackground)
        
        label.text = "20"
        label.fontSize = 45
        label.fontColor = SKColor.black
        label.position = location
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.fontName = "AvenirNext-Bold"
        self.addChild(label)
        
        createLine(location: location, angle: CGFloat.pi * (0.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (1.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (2.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (3.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (4.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (5.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (6.0/4.0))
        createLine(location: location, angle: CGFloat.pi * (7.0/4.0))*/
        
        
    }
    
    //Where logic loop occurs
    //updates the values and shapes of all the sensors
    override func update(_ currentTime: CFTimeInterval)
    {
        
        var changeLabels:Bool = false
        
        
        if(currentTime - lastTime > (1.0/8.0))
        {
            lastTime = currentTime
            changeLabels = true
        }
        
        var path:CGMutablePath = CGMutablePath()
        
        //Pitch Update
        let pitchRate:CGFloat = CGFloat(getAverage(data.y) - data.offsets.pitchOffset)
        
        
        var degreeValue:CGFloat = pitchRate * 57.2958;
        if changeLabels
        {
            lblPitchValue.text = String(abs(Int(degreeValue)))
            
        }
        var anglePitch = degreeValue * (CGFloat.pi/40.0) + startAnglePitch;
        if(anglePitch > startAnglePitch + CGFloat.pi)
        {
            anglePitch = startAnglePitch + CGFloat.pi
        }
        else if(anglePitch < startAnglePitch - CGFloat.pi)
        {
            anglePitch = startAnglePitch - CGFloat.pi
        }
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        if(anglePitch - startAnglePitch > 0)
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAnglePitch, endAngle: anglePitch, clockwise: false)
        }
        else
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAnglePitch, endAngle: anglePitch, clockwise: true)
        }
        path.addLine(to: CGPoint.zero)
        path.closeSubpath()
        pitchPie.path = path
        
        
        //Roll Update
        let rollRate:CGFloat = CGFloat(getAverage(data.z) - data.offsets.rollOffset)
        degreeValue = rollRate * 57.2958
        if changeLabels
        {
            lblRollValue.text = String(abs(Int(degreeValue)))
        }
        var angleRoll = degreeValue * (CGFloat.pi/360.0) + startAngleRoll
        if(angleRoll > startAngleRoll + CGFloat.pi)
        {
            angleRoll = startAngleRoll + CGFloat.pi
        }
        else if(angleRoll < startAngleRoll - CGFloat.pi)
        {
            angleRoll = startAngleRoll - CGFloat.pi
        }
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        if(angleRoll - startAngleRoll > 0)
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAngleRoll, endAngle: angleRoll, clockwise: false)
        }
        else
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAngleRoll, endAngle: angleRoll, clockwise: true)
        }
        path.addLine(to: CGPoint.zero)
        path.closeSubpath()
        rollPie.path = path
        
        
        //Yaw Update
        let yawRate:CGFloat = CGFloat(getAverage(data.x) - data.offsets.yawOffset)
        degreeValue = yawRate * 57.2958
        if changeLabels
        {
            lblYawValue.text = String(abs(Int(degreeValue)))
        }
        var angleYaw = (degreeValue * -1) * (CGFloat.pi/180.0) + startAngleYaw
        if(angleYaw > startAngleYaw + CGFloat.pi)
        {
            angleYaw = startAngleYaw + CGFloat.pi
        }
        else if(angleYaw < startAngleYaw - CGFloat.pi)
        {
            angleYaw = startAngleYaw - CGFloat.pi
        }
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        if(angleYaw - startAngleYaw > 0)
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAngleYaw, endAngle: angleYaw, clockwise: false)
        }
        else
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAngleYaw, endAngle: angleYaw, clockwise: true)
        }
        path.addLine(to: CGPoint.zero)
        path.closeSubpath()
        yawPie.path = path
        
        
        //Grav Update
        let gravRate:CGFloat = CGFloat(getAverage(data.grav) * -1)
        
        var temp = String(abs(Double(gravRate)))
        if(temp.count > 3)
        {
            temp.removeSubrange(temp.index(temp.startIndex, offsetBy: 3)..<temp.endIndex)
        }
        if changeLabels
        {
            lblGravValue.text = temp
        }
        let angleGrav = gravRate * (CGFloat.pi/6) + startAngleGrav
        
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        if(angleGrav - startAngleGrav > 0)
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAngleGrav, endAngle: angleGrav, clockwise: false)
        }
        else
        {
            path.addArc(center: CGPoint.zero, radius: radius, startAngle: startAngleGrav, endAngle: angleGrav, clockwise: true)
        }
        path.addLine(to: CGPoint.zero)
        path.closeSubpath()
        gravPie.path = path
        
        
        //GravDirectionBottom Update
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        var angleGravDirectionBottom = CGFloat(getAverage(data.gravDirection)) + startAngleGravDirectionBottom;
        
        if(gravRate > 0)
        {
            angleGravDirectionBottom = startAngleGravDirectionBottom;
        }
        
        if(angleGravDirectionBottom - startAngleGravDirectionBottom > 0)
        {
            path.addArc(center: CGPoint.zero, radius: partialRadius, startAngle: startAngleGravDirectionBottom, endAngle: angleGravDirectionBottom, clockwise: false)
        }
        else
        {
            path.addArc(center: CGPoint.zero, radius: partialRadius, startAngle: startAngleGravDirectionBottom, endAngle: angleGravDirectionBottom, clockwise: true)
        }
        path.addLine(to: CGPoint.zero)
        path.closeSubpath()
        gravDirectionBottomPie.path = path
        
        //GravDirectionTop Update
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        var angleGravDirectionTop = CGFloat(getAverage(data.gravDirection)) + startAngleGravDirectionTop;
        
        if(gravRate < 0)
        {
            angleGravDirectionTop = startAngleGravDirectionTop;
        }
        
        if(angleGravDirectionTop - startAngleGravDirectionTop > 0)
        {
            path.addArc(center: CGPoint.zero, radius: partialRadius, startAngle: startAngleGravDirectionTop, endAngle: angleGravDirectionTop, clockwise: false)
        }
        else
        {
            path.addArc(center: CGPoint.zero, radius: partialRadius, startAngle: startAngleGravDirectionTop, endAngle: angleGravDirectionTop, clockwise: true)
        }
        path.addLine(to: CGPoint.zero)
        path.closeSubpath()
        gravDirectionTopPie.path = path
        
        
        SKAction.wait(forDuration: 1.0/60.0)
        
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
    
    //used in determining calibration value
    func calibrate(_ numbers:[Double]) -> CGFloat
    {
        return CGFloat(getAverage(numbers))
    }
    
    
    
    //used as a calibration function but will have its own menu soon
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //calibrationVarPitch = calibrate(GameScene.y)
        //calibrationVarRoll = calibrate(GameScene.z)
        //calibrationVarYaw = calibrate(GameScene.x)
        
    }
    
    //get x,y location of a point starting from circles center given angle and radius from center
    func getPointInsideCircle(location: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint
    {
        return CGPoint(x: Darwin.cos(Double(angle))*Double(radius) + Double(location.x), y: Darwin.sin(Double(angle))*Double(radius) + Double(location.y))
    }
    
    //creates a small line
    //used on the instruments to indicate measurements
    func createLine(location: CGPoint, angle:CGFloat)
    {
        let point1 = getPointInsideCircle(location: location, angle: angle, radius: radius-10)
        let point2 = getPointInsideCircle(location: location, angle: angle, radius: radius+10)
        let line = CGMutablePath()
        line.move(to: point1)
        line.addLine(to: point2)
        line.closeSubpath()
        
        let lineNode:SKShapeNode = SKShapeNode(path: line)
        lineNode.strokeColor = SKColor.black
        lineNode.lineWidth = 5
        self.addChild(lineNode)
    }
    
    //Create labels to correspond with the lines drawn around the instruments
    func createTextForInstrument(location: CGPoint, angle:CGFloat, str: String)
    {
        let point = getPointInsideCircle(location: location, angle: angle, radius: radius+30)
        let label = SKLabelNode()
        label.text = str
        label.fontSize = 25
        label.fontColor = SKColor.black
        label.position = point
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.fontName = "AvenirNext-Bold"
        self.addChild(label)
    }
    
    //creates a title for an instrument
    func createLabel(location: CGPoint, str: String)
    {
        var loc = location
        loc.y -= (radius + 55)
        
        let label = SKLabelNode()
        label.text = str
        label.fontSize = 30
        label.fontColor = SKColor.black
        label.position = loc
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.fontName = "AvenirNext-Bold"
        self.addChild(label)
    }
    
    

    
    
}
