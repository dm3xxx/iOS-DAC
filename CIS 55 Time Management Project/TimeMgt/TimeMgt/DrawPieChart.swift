//
//  DrawPieChart.swift
//  TimeMgt
//
//  Created by cisstudents on 6/11/15.
//  Copyright (c) 2015 cisstudents. All rights reserved.
//

// ***** This class not using anymore! *****

import UIKit

class DrawPieChart: NSObject {
    
    let pi = CGFloat(M_PI)
    let twoPi = 2.0 * CGFloat(M_PI)
    let minPerDay : CGFloat = 1440.0
    
    var parentView : UIView!
    var startAngle : CGFloat!
    var center : CGPoint!
    var radius : CGFloat!
   
    init(view: UIView, ctr: CGPoint, rad: CGFloat) {
        startAngle = 1.5 * pi   // set init angle at 12 o'clock
        center = ctr
        radius = rad
        parentView = view
    }
    
    func draw(events: [Events], types: [String]) {
        
        for e in events {
            let less = min(e.sTime.count, e.eTime.count)
            let idx = find(types, e.name)
            var eMins = 0
            for ii in 0..<less {
                eMins +=  NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: e.sTime[ii], toDate: e.eTime[ii], options: nil).minute
            }
            
            // draw here
            let endAngle = (startAngle + (2.0 * CGFloat(eMins) / minPerDay * pi)) % twoPi
            let path = UIBezierPath()
            path.moveToPoint(center)
            path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLineToPoint(center)
            path.closePath()
            
            let slide = CAShapeLayer()
            slide.path = path.CGPath
            slide.fillColor = colorIdx[idx!].CGColor
            slide.strokeColor = UIColor.clearColor().CGColor
            
            parentView.layer.addSublayer(slide)
            startAngle = endAngle
        }
        
    }
}


//let path = UIBezierPath()
//path.moveToPoint(center)
//path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//path.addLineToPoint(center)
//path.closePath()
//
//let pie = CAShapeLayer()
//pie.path = path.CGPath
//pie.fillColor = UIColor.brownColor().CGColor
//pie.strokeColor = UIColor.clearColor().CGColor
//
//thisView.layer.addSublayer(pie)
//return endAngle