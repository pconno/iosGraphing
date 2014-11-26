//
//  FNKChart.swift
//  Charts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 FNK. All rights reserved.
//

import Foundation
import UIKit

class FNKChart : NSObject {
    var xAxis :FNKXAxis;
    var yAxis :FNKYAxis;
    var yLabelView : UIView;
    var xLabelView : UIView;
    var yPadding : CGFloat;
    
    init(marginLeft : CGFloat, marginRight : CGFloat, marginTop : CGFloat, marginBottom: CGFloat, graphWidth : CGFloat, graphHeight : CGFloat) {
        xAxis = FNKXAxis(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight);
        yAxis = FNKYAxis(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight);
        yLabelView = UIView();
        xLabelView = UIView();
        yPadding = 0;
        super.init();
    }
    
    func draw(view : UIView)
    {
        yLabelView = yAxis.addTicksToView(view);
        xLabelView = xAxis.addTicksToView(view);
    }
    
    func drawAxii(view : UIView)
    {
        yAxis.drawAxis(view);
        
//        xAxis.drawAxis(view);
    }
}