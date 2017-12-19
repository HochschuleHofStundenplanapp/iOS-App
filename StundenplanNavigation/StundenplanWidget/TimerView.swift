//
//  TimerView.swift
//  TimerTest
//
//  Created by Philipp on 01.12.17.
//  Copyright © 2017 Philipp. All rights reserved.
//

import UIKit
@IBDesignable
class TimerView: UIView {

    var percentageOfHour = 0.5
    var lineWidth : CGFloat!
    var circleColor : CGColor = UIColor.green.cgColor
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        lineWidth = rect.size.width/10
        
        
        createGreyCircle(rect)
        
        createColorCircle(rect)
    }
    
    func createGreyCircle(_ rect: CGRect){
        let shapeLayer = CAShapeLayer()
        let greyCircle = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2,y:rect.size.height/2), radius: rect.size.height/2, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        
        shapeLayer.path = greyCircle.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = lineWidth
        
        layer.addSublayer(shapeLayer)
    }
    
    func createColorCircle(_ rect : CGRect){
        let shapeLayer = CAShapeLayer()
        let colorCircle = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2,y:rect.size.height/2), radius: rect.size.height/2, startAngle: CGFloat(Double.pi*1.5), endAngle: CGFloat(Double.pi*1.5+((Double.pi*2)*percentageOfHour)), clockwise: true)
        
        shapeLayer.path = colorCircle.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = circleColor
        shapeLayer.lineWidth = lineWidth
        
        layer.addSublayer(shapeLayer)
    }

}
