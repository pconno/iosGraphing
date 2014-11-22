//
//  CLLLineChart.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import Foundation
import UIKit

class CLLLineChart : CLLChart {
    
    var lineFillColor : CGColor = UIColor.clearColor().CGColor;
    var lineStrokeColor : CGColor = UIColor.blueColor().CGColor;
    
    override init()
    {
        super.init();
    }
    
    override init(marginLeft : CGFloat, marginRight : CGFloat, marginTop : CGFloat, marginBottom: CGFloat, graphWidth : CGFloat, graphHeight : CGFloat, xScaleFactor : CGFloat, yScaleFactor : CGFloat, yAxisNum : CGFloat) {
        
        super.init(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight, xScaleFactor: xScaleFactor, yScaleFactor: yScaleFactor, yAxisNum: yAxisNum);
    }
    
}