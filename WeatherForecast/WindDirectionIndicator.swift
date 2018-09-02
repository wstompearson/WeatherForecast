//
//  WindDirectionIndicator.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 28/04/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import UIKit

@IBDesignable
class WindDirectionIndicator: UIView {
    override func draw(_ rect: CGRect) {
        let innerCircleScale: CGFloat = 0.45
        let centerPoint: CGPoint = CGPoint(x: bounds.width / 2 , y: bounds.height / 2)
        let xOrigin: CGFloat = (bounds.width * (1 - innerCircleScale)) / 2
        let yOrigin: CGFloat = (bounds.height * (1 - innerCircleScale)) / 2
        let innerCircleBounds = CGRect(x: xOrigin, y: yOrigin, width: bounds.width * innerCircleScale, height: bounds.height * innerCircleScale)
        
        let circle = UIBezierPath(ovalIn: innerCircleBounds)
        UIColor.white.setFill()
        circle.fill()
        
        let lineWidth: CGFloat = 3
        
        let arrowPath = UIBezierPath()
        arrowPath.lineWidth = lineWidth
        
        arrowPath.move(to: centerPoint)
        let arrowTip = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.05)
        arrowPath.addLine(to: arrowTip)
        
        let arrowVerticalPosition: CGFloat = bounds.height * 0.2
        let arrowHorizontalSeparation: CGFloat = bounds.width * 0.1
        
        arrowPath.move(to: CGPoint(x: centerPoint.x - arrowHorizontalSeparation, y: arrowVerticalPosition))
        arrowPath.addLine(to: arrowTip)
        
        arrowPath.addLine(to: CGPoint(x: centerPoint.x + arrowHorizontalSeparation, y: arrowVerticalPosition))
        
        
        UIColor.white.setStroke()
        arrowPath.stroke()
    }
}
