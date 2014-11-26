//
//  FNKXAxis.swift
//  FNKCharts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 FitnessKeeper inc. All rights reserved.
//

import Foundation
import UIKit

class FNKXAxis : FNKAxis {
        
    override func drawAxis(view : UIView)
    {
        var bezPath: UIBezierPath = UIBezierPath();
        bezPath.moveToPoint(CGPointMake(marginLeft, graphHeight + marginTop));
        bezPath.addLineToPoint(CGPointMake(graphWidth + marginLeft, graphHeight + marginTop));
        bezPath.closePath();
        
        var layer: CAShapeLayer = CAShapeLayer();
        layer.path = bezPath.CGPath;
        layer.fillColor = fillColor;
        layer.strokeColor = strokeColor;
        
        view.layer.addSublayer(layer);
    }
    
    override func addTicksToView(view : UIView) ->UIView
    {
        var tickInterval : CGFloat = graphWidth / CGFloat(self.ticks);
        
        var labelView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 20));
        
        for index in 0...self.ticks
        {
            
            var bezPath: UIBezierPath = UIBezierPath();
        
            var xVal: CGFloat = marginLeft + CGFloat(CGFloat(index) * tickInterval);
            var yVal: CGFloat = marginTop + graphHeight;
            
            bezPath.moveToPoint(CGPointMake(xVal, yVal));
            bezPath.addLineToPoint(CGPointMake(xVal, yVal + 3));
            
            var layer: CAShapeLayer = CAShapeLayer();
            layer.path = bezPath.CGPath;
            layer.fillColor = tickFillColor;
            layer.strokeColor = tickStrokeColor;
            
            view.layer.addSublayer(layer);
            
            //Okay those are the ticks. Now we need the labels
            var textWidth:CGFloat = 20;
            var tickLabel:UILabel = UILabel();
            tickLabel.text = tickFormat(value : Float(xVal / scaleFactor));
            tickLabel.frame = CGRectMake( xVal - textWidth/2, yVal + 5, textWidth, 10);
            tickLabel.textAlignment = NSTextAlignment.Center;
            tickLabel.font = tickFont;
            labelView.addSubview(tickLabel);
        }
        
        view.addSubview(labelView);
        
        return labelView;
    }
}