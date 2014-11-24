//
//  CLLChartOverlayBars.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/23/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import Foundation
import UIKit

class CLLChartOverlayBars : CLLChartOverlayBase {

    var dataSet : NSArray?
    var barsArray : NSMutableArray?
    
    func drawInView(view : UIView)
    {
        updateChartData()
        
        barsArray = NSMutableArray();
        var bars = dataSet?.count
        for index in 0...bars!-1
        {
            var data : CLLBarOverlayData = dataSet?.objectAtIndex(index) as CLLBarOverlayData
            var barView : CLLBar = CLLBar(data: data, frame: CGRectMake(data.x + marginLeft!, graphHeight! + marginTop!, data.width!, 0))
            barView.backgroundColor = randomColor()
            barView.alpha = 0.1
            view.insertSubview(barView, atIndex: 6)
            
            barsArray?.addObject(barView)
            
            var delay = Double(0.1*Float(index))
            
            UIView.animateWithDuration(2, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                barView.originalFrame = CGRectMake(data.x + self.marginLeft!, self.marginTop!, data.width!, self.graphHeight!)
                barView.frame = CGRectMake(data.x + self.marginLeft!, self.marginTop!, data.width!, self.graphHeight!)
                }, completion: { (Bool) -> Void in
                    
            })
        }
    }
    
    func randomColor() ->UIColor
    {
        var aRedValue = CGFloat((arc4random()%255));
        var aGreenValue = CGFloat((arc4random()%255));
        var aBlueValue = CGFloat((arc4random()%255));
        
        return  UIColor(red: aRedValue/256.0, green: aGreenValue/256.0, blue: aBlueValue/256.0, alpha: 1);
    }
    
    func updateChartData()
    {
        if let dSet = dataSet
        {
            var prevBarData : CLLBarOverlayData?
            for data in dSet
            {
                var barData : CLLBarOverlayData = data as CLLBarOverlayData
                
                barData.x = barData.x * self.scale!
                
                if prevBarData != nil
                {
                    var x = prevBarData?.x
                    var w = barData.x - x!
                    prevBarData?.width = w
                }
                
                prevBarData = barData
            }
            
            var x = prevBarData?.x
            var w = graphWidth! - x!
            prevBarData?.width = w
        }
    }
    
    func touchAtPoint(point : CGPoint, view : UIView) -> CLLBarOverlayData?
    {
        var touchedData : CLLBarOverlayData?
        if let bArray = barsArray
        {
            for barView in bArray
            {
                var bView : CLLBar = barView as CLLBar
                var cPoint = view.convertPoint(point, toView: bView)
                var expand : Bool = bView.pointInside(cPoint, withEvent: nil)
                
                if expand
                {
                    touchedData = bView.data
                }
            
                bView.updateBar(expand)
            }
        }
        
        return touchedData
    }
}