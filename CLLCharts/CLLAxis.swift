//
//  CLLAxis.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import Foundation
import UIKit

enum CLLTickType {
    case Outside, Behind
}

class CLLAxis : NSObject {
    
    //Graph Sizes
    var marginLeft : CGFloat;
    var marginTop : CGFloat;
    var marginRight : CGFloat;
    var marginBottom : CGFloat;
    var graphHeight : CGFloat;
    var graphWidth : CGFloat;
    var scaleFactor : CGFloat!;
    
    var tickType : CLLTickType = CLLTickType.Outside;
    
    var ticks: Int = 5;
    var fillColor : CGColor = UIColor.blackColor().CGColor;
    var strokeColor : CGColor = UIColor.blackColor().CGColor;
    
    var tickFillColor : CGColor =  UIColor.blackColor().CGColor;
    var tickStrokeColor : CGColor =  UIColor.blackColor().CGColor;
    
    var tickFont : UIFont;
    
    var tickFormat: (value: Float) -> (NSString);
    
    override init(){
        tickFormat = {
            (arg:Float) -> NSString in
            return ""
        }
        self.marginLeft = 0;
        self.marginRight = 0;
        self.marginTop = 0;
        self.marginBottom = 0;
        self.graphWidth = 0;
        self.graphHeight = 0;
        self.scaleFactor = 0;
        tickFont = UIFont(name: "Avenir", size: 9)!
        super.init();
    }
    
    init(marginLeft : CGFloat, marginRight : CGFloat, marginTop : CGFloat, marginBottom: CGFloat, graphWidth : CGFloat, graphHeight : CGFloat) {
        tickFormat = {
            (arg:Float) -> NSString in
            return ""
        }
        self.marginLeft = marginLeft;
        self.marginRight = marginRight;
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
        self.graphWidth = graphWidth;
        self.graphHeight = graphHeight;
        tickFont = UIFont(name: "Avenir", size: 9)!
        super.init();
    }
    
    func drawAxis(view : UIView)
    {
    }
    
    func addTicksToView(view : UIView) ->UIView
    {
        return UIView();
    }
}
