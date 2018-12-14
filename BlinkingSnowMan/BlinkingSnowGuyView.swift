//
//  Snowguy.swift
//  drawSnowman
//
//  Created by Rustam Shorov on 22.11.2018.
//  Copyright © 2018 Rustam Shorov. All rights reserved.
//

import UIKit

protocol EyesOpeningDelegate {
    func openEyes() -> Bool
}
//@IBDesignable

class Snowguy: UIView{
    
    var armStartPosition: CAShapeLayer!
    var armFinishPosition: CAShapeLayer!
//    
//    func drawArms() {
//        
//        armStartPosition = CAShapeLayer()
//        let veryFirstArmPoint = CGPoint(x: 200, y: 80)
//        var arm = UIBezierPath()
//        arm.move(to: veryFirstArmPoint)
//        arm.addLine(to: )
//        
//    }
    
    var delegateOpenEyes: EyesOpeningDelegate?
    
    
    var mood: Float = 1
    //MARK: Constants structure
    private struct Constants {
        
        //forEyes
        static let headRadiusToEyeOffset: CGFloat = 2.5
        static let headRadiusToEyeRadius: CGFloat = 5
        //forNose
        static let headCenterToNose: CGFloat = 6
        static let noseLenght: CGFloat = 20
        //forMouth
        static let headRaduisToMouthOffset: CGFloat = 5
        static let headRadiusToMouthWidth: CGFloat = 3.5
        static let headRadiusToMouthHeight: CGFloat = 3.5
        // fist
        //enumForEyesAndArms
        enum Side {
            case left
            case right
        }
    }
    
    //Variable height for dif screens and albumView
    private var height: CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    // Radiuses of Circles
    private var headRadius: CGFloat {
        return height / 10
    }
    private var middleRadius: CGFloat {
        return height / 7
    }
    private var bottomRadius: CGFloat {
        return height / 5
    }
    //Finding centers of Circles
    private var headCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY - 2 * middleRadius )
    }
    private var midCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY + headRadius - middleRadius)
    }
    private var bottomCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY + headRadius + bottomRadius)
    }
    private var fingerLength: CGFloat {
        return height / 30
    }
    private var shoulderLength: CGFloat {
        return middleRadius
    }
    private var shoulderEndPoint: CGPoint {
        return CGPoint(x: midCenter.x + 2 * shoulderLength, y: midCenter.y - shoulderLength)
    }
    // ----------------
    
    //MARK: Functions for Drawing
    //MARK: BODY
    private func drawHead() -> UIBezierPath {
        let headCircle = UIBezierPath(arcCenter: headCenter, radius: headRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        headCircle.lineWidth = 3
        return headCircle
    }
    private func drawMiddle() -> UIBezierPath {
        let middleCircle = UIBezierPath(arcCenter: midCenter, radius: middleRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        return middleCircle
    }
    
    private func drawBottom() -> UIBezierPath {
        let bottomCircle = UIBezierPath(arcCenter: bottomCenter, radius: bottomRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        return bottomCircle
    }
    //      ----------------
    
    
    // ARM
    func drawMood() -> UIBezierPath {
        let middleFinger = UIBezierPath()
        let fistWidth: CGFloat = 25
        let fistHeight: CGFloat = 18
        
        middleFinger.move(to: CGPoint(x: midCenter.x + shoulderLength , y: midCenter.y))
        middleFinger.addLine(to: CGPoint(x: midCenter.x + 1.5 * shoulderLength, y: midCenter.y))
        middleFinger.addLine(to: shoulderEndPoint)
        middleFinger.lineWidth = 3
        
        func drawFist() -> UIBezierPath {
            let fist = UIBezierPath(rect: CGRect(x: shoulderEndPoint.x - fistWidth / 5, y: shoulderEndPoint.y - fistHeight, width: fistWidth, height: fistHeight))
            return fist
        }
        
        func drawFinger() -> UIBezierPath {
            let finger = UIBezierPath()
            finger.move(to: CGPoint(x: shoulderEndPoint.x, y: shoulderEndPoint.y - fistHeight))
            finger.addLine(to: CGPoint(x: shoulderEndPoint.x, y: shoulderEndPoint.y - 2 * fistHeight))
            finger.lineWidth = 2
            return finger
        }
        drawFinger().stroke()
        drawFist().fill()
        return middleFinger
    }
    //    ----------------
    //    MARK: FEET
    private func drawFeet(foot: Constants.Side) -> UIBezierPath {
        func findFootCenter(_ foot: Constants.Side) -> CGPoint {
            let footOffset = bottomRadius / 2
            var footCenter = CGPoint(x: bottomCenter.x, y: bottomCenter.y + bottomRadius)
            footCenter.x += ((foot == .left) ? -1 : 1) * footOffset
            return footCenter
        }
        let footPath = UIBezierPath()
        let footRadius = bottomRadius / 5
        let footCenter = findFootCenter(foot)
        footPath.addArc(withCenter: footCenter, radius: footRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        return footPath
    }
    
    //    ----------------
    //    MARK: HEAD
    //     EYES
    private func drawEyes(eye: Constants.Side) -> UIBezierPath {
        func findEyeCenter(_ eye: Constants.Side) -> CGPoint {
            let eyeOffset = headRadius / Constants.headRadiusToEyeOffset
            var eyeCenter = headCenter
            eyeCenter.x += ((eye == .left ) ? -1 : 1) * eyeOffset
            eyeCenter.y -= eyeOffset
            return eyeCenter
        }
        var eyePath = UIBezierPath()
        let eyeRadius = headRadius / Constants.headRadiusToEyeRadius
        let eyeCenter = findEyeCenter(eye)
        
        let isEyeClosed = delegateOpenEyes?.openEyes() ?? true
        
        if isEyeClosed {
            eyePath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            eyePath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            return eyePath
        }
        eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        eyePath.lineWidth = 2
        return eyePath
    }
    //      ----------------
    
    //    NOSE
    private func drawNose() -> UIBezierPath {
        let nosePath = UIBezierPath()
        nosePath.move(to: CGPoint(x: headCenter.x, y: headCenter.y - Constants.headCenterToNose))
        nosePath.addLine(to: CGPoint(x: headCenter.x + Constants.noseLenght, y: headCenter.y + headRadius / 3))
        nosePath.addLine(to: CGPoint(x: headCenter.x, y: headCenter.y + Constants.headCenterToNose))
        nosePath.close()
        return nosePath
    }
    //      ----------------
    
    //    MOUTH
    private func drawMouth() -> UIBezierPath {
        let mouthPath = UIBezierPath()
        let mouthWidth = headRadius / Constants.headRadiusToMouthWidth
        let mouthHeight = headRadius / Constants.headRadiusToMouthHeight
        let mouthOffset = headRadius / Constants.headRaduisToMouthOffset
        
        let controlPointOffset = CGFloat(max(-1, min(1, mood))) * mouthHeight
        
        let mouthRect = CGRect(x: headCenter.x - mouthWidth, y: headCenter.y + mouthOffset, width: 2 * mouthWidth, height: 2 * mouthHeight)
        
        let startPoint = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let endPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: startPoint.x + mouthRect.width / 3, y: startPoint.y + controlPointOffset)
        let cp2 = CGPoint(x: endPoint.x - mouthRect.width / 3, y: startPoint.y + controlPointOffset)
        
        mouthPath.move(to: startPoint)
        mouthPath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        mouthPath.lineWidth = 2
        return mouthPath
    }
    
    func drawSomeSquare() -> UIBezierPath {
        let busketPath = UIBezierPath()
        busketPath.addArc(withCenter: CGPoint(x: 30, y: 30), radius: 5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        return busketPath
    }
    //      ----------------
    
    //    MARK: Drawing!
    override func draw(_ rect: CGRect) {
        
        UIColor.blue.setStroke()
        drawHead().stroke()
        UIColor.green.setFill()
        drawMiddle().fill()
        UIColor.brown.setFill()
        drawFeet(foot: .left).fill()
        drawFeet(foot: .right).fill()
        UIColor.blue.setFill()
        drawBottom().fill()
        UIColor.brown.setStroke()
        UIColor.black.setStroke()
        UIColor.brown.setFill()
        drawNose().fill()
        drawEyes(eye: .left).stroke()
        drawEyes(eye: .right).stroke()
        UIColor.red.setStroke()
        drawMouth().stroke()
        UIColor.brown.setStroke()
        drawMood().stroke()
//        drawSomeSquare().stroke()
        UIGraphicsPopContext()
    }
}
