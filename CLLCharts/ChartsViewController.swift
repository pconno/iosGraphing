//
//  ViewController.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/20/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import UIKit


class ChartsViewController: UIViewController {
    
    var dataPointArray: Array<CGPoint> = [];
    var marginLeft: CGFloat = 20.0;
    var marginRight: CGFloat = 20.0;
    var marginTop: CGFloat = 5.0;
    var marginBottom: CGFloat = 5.0;
    var graphWidth: CGFloat = 0.0;
    var graphHeight: CGFloat = 0.0;
    
    //Graph variables 
    var xScaleFactor: CGFloat = 0.0;
    var yScaleFactor: CGFloat = 0.0;
    var xRange: CGFloat = 0.0;
    var yRange: CGFloat = 0.0;
    
    var yPadding : CGFloat;
    var yAxisNum : CGFloat;
    
    var chart: CLLLineChart;
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.yPadding = 40;
        self.marginLeft = 20.0;
        self.marginRight = 20.0;
        self.marginTop = 5.0;
        self.marginBottom = 5.0;
        self.graphWidth = 0.0;
        self.graphHeight = 0.0;
        self.xScaleFactor = 0.0;
        self.yScaleFactor  = 0.0;
        self.xRange = 0.0;
        self.yRange = 0.0;
        
        self.yPadding = 0;
        self.yAxisNum = 0;
        chart = CLLLineChart();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupGraph()
    {
        self.graphWidth = self.view.frame.width - self.marginRight - self.marginLeft;
        self.graphHeight = self.view.frame.size.height - self.marginTop - self.marginBottom;
        
        self.dataPointArray = normalizePoints(dataPointArray);
        
        chart = CLLLineChart(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight, xScaleFactor : xScaleFactor, yScaleFactor : yScaleFactor, yAxisNum : yAxisNum);
        chart.xAxis.ticks = 5;
        chart.yAxis.ticks = 5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        chart.drawAxii(self.view);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        drawPoints();
    }
        
    
    func drawPoints()
    {
        var firstPoint: Bool = true;
        
        var bezPath: UIBezierPath = UIBezierPath();
        
        for point: CGPoint in self.dataPointArray{
            
            if firstPoint
            {
                bezPath.moveToPoint(point)
                firstPoint = false
            }
            else
            {
                bezPath.addLineToPoint(point)
            }
        }
        
        var layer: CAShapeLayer = CAShapeLayer();
        layer.path = bezPath.CGPath;
        layer.fillColor = chart.lineFillColor;
        layer.strokeColor = chart.lineStrokeColor;
        layer.lineWidth = 2;
        layer.lineCap = "round";
        layer.lineJoin = "round";
        
        self.view.layer.insertSublayer(layer, below: chart.yLabelView.layer);
        
        var pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2;
        pathAnimation.fromValue = 0.0;
        pathAnimation.toValue = 1.0;
        
        layer.addAnimation(pathAnimation, forKey: "strokeEnd");
    }
    
    func normalizePoints(points : Array<CGPoint>)->Array<CGPoint>
    {
        var maxX: CGFloat = CGFloat(DBL_MIN);
        var minX: CGFloat = CGFloat(DBL_MAX);
        var maxY: CGFloat = CGFloat(DBL_MIN);
        var minY: CGFloat = CGFloat(DBL_MAX);
        
        for point: CGPoint in points{
            
            if(point.x > maxX)
            {
                maxX = point.x;
            }
            
            if(point.x < minX)
            {
                minX = point.x;
            }
            
            if(point.y > maxY)
            {
                maxY = point.y;
            }
            
            if(point.y < minY)
            {
                minY = point.y;
            }
        }
        
        yAxisNum = minY - yPadding;
        
        maxY = maxY + yPadding;
        
        //Okay so now we have the min's and max's
        self.xRange = maxX - minX;
        self.yRange = maxY - minY;
        
        self.xScaleFactor = self.graphWidth / self.xRange
        self.yScaleFactor = self.graphHeight / self.yRange
        
        var scaledPoints :Array<CGPoint> = Array();
        
//        var scaledPoint = self.graphHeight + self.marginTop - ((point.y - yAxisNum) * yScaleFactor);
//        scaledPoint - self.graphHeight - self.marginTop = - ((point.y - yAxisNum) * yScaleFactor);
//        self.marginTop + self.graphHeight - scaledPoint = ((point.y - yAxisNum) * yScaleFactor);
//        point.y = ((self.marginTop + self.graphHeight - scaledPoint) / yScaleFactor) + yAxisNum
        
        
        for point: CGPoint in points{
            var xVal :CGFloat = (point.x * xScaleFactor) + self.marginLeft;
            var yVal : CGFloat = self.graphHeight + self.marginTop - ((point.y - yAxisNum) * yScaleFactor); //yVal needs to be the inverse bc of iOS coordinates
            scaledPoints.append(CGPointMake(xVal,yVal));
        }
        
        return scaledPoints;
    }
}

