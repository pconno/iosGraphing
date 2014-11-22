//
//  CLLChart.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/21/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import Foundation
import UIKit

class CLLChart : NSObject {
    var xAxis :CLLXAxis;
    var yAxis :CLLYAxis;
    var yLabelView : UIView;
    var xLabelView : UIView;
    var yPadding : CGFloat;
    
    override init()
    {
        xAxis = CLLXAxis();
        yAxis = CLLYAxis();
        yLabelView = UIView();
        xLabelView = UIView();
        yPadding = 0;
        super.init();
    }
    
    init(marginLeft : CGFloat, marginRight : CGFloat, marginTop : CGFloat, marginBottom: CGFloat, graphWidth : CGFloat, graphHeight : CGFloat, xScaleFactor : CGFloat, yScaleFactor : CGFloat, yAxisNum : CGFloat) {
        xAxis = CLLXAxis(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight, scaleFactor: xScaleFactor);
        yAxis = CLLYAxis(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight, scaleFactor: yScaleFactor, yAxisNum: yAxisNum
        );
        yLabelView = UIView();
        xLabelView = UIView();
        yPadding = 0;
        super.init();
    }
    
    func drawAxii(view : UIView)
    {
        view.layer.addSublayer(yAxis.drawAxis());
        yLabelView = yAxis.addTicksToView(view);
        
        view.layer.addSublayer(xAxis.drawAxis());
        xLabelView = xAxis.addTicksToView(view);
    }
}