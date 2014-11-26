//
//  FNKYAxis.swift
//  FNKCharts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 FitnessKeeper inc. All rights reserved.
//

import Foundation
import UIKit

class FNKYAxis : FNKAxis {
    
    var yAxisNum : CGFloat = 0;
    
    override func drawAxis(view : UIView)
    {
        //Draw axis
        var bezPath: UIBezierPath = UIBezierPath();
        bezPath.moveToPoint(CGPointMake(marginLeft, marginTop));
        bezPath.addLineToPoint(CGPointMake(marginLeft, graphHeight + marginTop));
        bezPath.closePath();
        
        var layer: CAShapeLayer = CAShapeLayer();
        layer.path = bezPath.CGPath;
        layer.fillColor = fillColor;
        layer.strokeColor = strokeColor;
        
        view.layer.addSublayer(layer);
        
        var pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2;
        pathAnimation.fromValue = 0.0;
        pathAnimation.toValue = 1.0;
        
        layer.addAnimation(pathAnimation, forKey: "strokeEnd");
        
        //Draw all lines
        var tickInterval : CGFloat = graphHeight / CGFloat(self.ticks);
        for index in 0...self.ticks
        {
            var bezPath: UIBezierPath = UIBezierPath();
            var xVal: CGFloat = marginLeft;
            var yVal: CGFloat = marginTop + CGFloat(CGFloat(index)*tickInterval);
            
            bezPath.moveToPoint(CGPointMake(xVal, yVal));
            
            if(tickType == FNKTickType.Outside)
            {
                bezPath.addLineToPoint(CGPointMake(xVal - 3.0, yVal));
            }
            else if(tickType == FNKTickType.Behind)
            {
                bezPath.addLineToPoint(CGPointMake(xVal + graphWidth, yVal));
            }
            
            var layer: CAShapeLayer = CAShapeLayer();
            layer.path = bezPath.CGPath;
            layer.fillColor = tickFillColor;
            layer.strokeColor = tickStrokeColor;
            
            view.layer.addSublayer(layer);
            
            var pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 2;
            pathAnimation.fromValue = 0.0;
            pathAnimation.toValue = 1.0;
            
            layer.addAnimation(pathAnimation, forKey: "strokeEnd");
        }
    }
    
    override func addTicksToView(view : UIView) ->UIView
    {
        var tickInterval : CGFloat = graphHeight / CGFloat(self.ticks);
        
        var labelView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height));
        
        for index in 0...self.ticks
        {
            var yVal: CGFloat = marginTop + CGFloat(CGFloat(index)*tickInterval);
            
            if index == self.ticks
            {
                continue;
            }
            //Okay those are the ticks. Now we need the labels
            var textWidth:CGFloat = 30;
            var textHeight:CGFloat = 10;
            var tickLabel:UILabel = UILabel();
            
            var originalVal = ((self.marginTop + self.graphHeight - yVal) / scaleFactor) + yAxisNum
            
//            ((graphHeight - yAxisNum + yVal) - graphHeight)/scaleFactor
            tickLabel.text = tickFormat(value :Float(originalVal));
            tickLabel.frame = CGRectMake(0, yVal - textHeight/2, textWidth, textHeight);
            tickLabel.textAlignment = NSTextAlignment.Right;
            tickLabel.font = tickFont;
            labelView.addSubview(tickLabel);
        }
        
        view.addSubview(labelView);
        
        return labelView;
    }
}