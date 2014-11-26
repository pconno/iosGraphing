//
//  FNKChartOverlayBars.swift
//  FNKCharts
//
//  Created by Phillip Connaughton on 11/23/14.
//  Copyright (c) 2014 FitnessKeeper inc. All rights reserved.
//

import Foundation
import UIKit

class FNKChartOverlayBars : FNKChartOverlayBase {

    var dataSet : NSArray?
    var barsArray : NSMutableArray?
    
    func drawInView(view : UIView)
    {
        updateChartData()
        
        barsArray = NSMutableArray();
        var bars = dataSet?.count
        for index in 0...bars!-1
        {
            var data : FNKBarOverlayData = dataSet?.objectAtIndex(index) as FNKBarOverlayData
            var barView : FNKBar = FNKBar(data: data, frame: CGRectMake(data.x + marginLeft!, graphHeight! + marginTop!, data.width!, 0))
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
            var prevBarData : FNKBarOverlayData?
            for data in dSet
            {
                var barData : FNKBarOverlayData = data as FNKBarOverlayData
                
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
    
    func touchAtPoint(point : CGPoint, view : UIView) -> FNKBarOverlayData?
    {
        var touchedData : FNKBarOverlayData?
        if let bArray = barsArray
        {
            for barView in bArray
            {
                var bView : FNKBar = barView as FNKBar
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