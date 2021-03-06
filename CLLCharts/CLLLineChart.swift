//
//  FNKLineChart.swift
//  FNKCharts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 FNK. All rights reserved.
//

import Foundation
import UIKit

class FNKLineChart : FNKChart {
    
    var lineFillColor : CGColor = UIColor.clearColor().CGColor;
    var lineStrokeColor : CGColor = UIColor.blueColor().CGColor;
    
    override init(marginLeft : CGFloat, marginRight : CGFloat, marginTop : CGFloat, marginBottom: CGFloat, graphWidth : CGFloat, graphHeight : CGFloat) {
        
        super.init(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight);
    }
    
}