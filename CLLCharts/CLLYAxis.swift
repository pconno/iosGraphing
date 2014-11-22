//
//  CLLYAxis.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import Foundation
import UIKit

class CLLYAxis : CLLAxis {
    
    var yAxisNum : CGFloat;
    
    override init()
    {
        yAxisNum = 0;
        super.init();
    }
    
    init(marginLeft : CGFloat, marginRight : CGFloat, marginTop : CGFloat, marginBottom: CGFloat, graphWidth : CGFloat, graphHeight : CGFloat, scaleFactor : CGFloat, yAxisNum : CGFloat) {
        self.yAxisNum = yAxisNum;
        super.init(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight, scaleFactor: scaleFactor);
    }
    
    override func drawAxis() ->CAShapeLayer
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
        
        return layer;
    }
    
    override func addTicksToView(view : UIView) ->UIView
    {
        var tickInterval : CGFloat = graphHeight / CGFloat(self.ticks);
        
        var labelView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height));
        
        for index in 0...self.ticks
        {
            var bezPath: UIBezierPath = UIBezierPath();
            var xVal: CGFloat = marginLeft;
            var yVal: CGFloat = marginTop + CGFloat(CGFloat(index)*tickInterval);
            
            bezPath.moveToPoint(CGPointMake(xVal, yVal));
            
            if(tickType == CLLTickType.Outside)
            {
                bezPath.addLineToPoint(CGPointMake(xVal - 3.0, yVal));
            }
            else if(tickType == CLLTickType.Behind)
            {
                bezPath.addLineToPoint(CGPointMake(xVal + graphWidth, yVal));
            }
            
            var layer: CAShapeLayer = CAShapeLayer();
            layer.path = bezPath.CGPath;
            layer.fillColor = tickFillColor;
            layer.strokeColor = tickStrokeColor;
            
            view.layer.addSublayer(layer);
            
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