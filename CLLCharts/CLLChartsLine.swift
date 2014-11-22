//
//  CLLChartsLine.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/20/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import Foundation
import CoreGraphics

class CLLChartsLine : NSObject {
    let point1, point2 : CGPoint;
    let b,slope : CGFloat;
    let verticalLine : Bool;
    init(point1 : CGPoint, point2 : CGPoint) {
        // perform some initialization here
        self.point1 = point1;
        self.point2 = point2;
        self.verticalLine = false;
        self.slope = 0;
        
        if(self.point1.x - self.point2.x == 0)
        {
            self.verticalLine = true;
        }
        else
        {
            self.slope = (self.point1.y - self.point2.y) / (self.point1.x - self.point2.x);
        }
        // y = mx + b
        // b = y - mx;
        self.b = point1.y - (self.slope * point1.x);
    }
    
    func getYLocationFor(x : CGFloat) -> CGFloat
    {
        //y = mx + b
        return (self.slope * x) + self.b;
    }
    
    func getXLocationFor(y : CGFloat) -> CGFloat
    {
        // (y - b) / m = x
        if(self.verticalLine)
        {
            return self.point1.x;
        }
        else
        {
            return (y - self.b) / self.slope;
        }
    }
}