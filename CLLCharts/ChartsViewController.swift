//
//  ViewController.swift
//  CLLCharts
//
//  Created by Phillip Connaughton on 11/20/14.
//  Copyright (c) 2014 cll. All rights reserved.
//

import UIKit

protocol ChartsViewDelegate {
    func touchedGraph(chart : ChartsViewController , val : CGFloat)
    func touchedBar(chart : ChartsViewController , data : CLLBarOverlayData)
}


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
    
    var drawBars : Bool;
    
    var chart: CLLLineChart;
    
    var delegate: ChartsViewDelegate?;
    var chartOverlay : CLLChartOverlayBars?
    
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
        self.drawBars = false
        chart = CLLLineChart();
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var panGesture = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        self.view.addGestureRecognizer(panGesture)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setupGraph()
    {
        self.graphWidth = self.view.frame.width - self.marginRight - self.marginLeft;
        self.graphHeight = self.view.frame.size.height - self.marginTop - self.marginBottom;
        
        chart = CLLLineChart(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: graphWidth, graphHeight: graphHeight, xScaleFactor : xScaleFactor, yScaleFactor : yScaleFactor, yAxisNum : yAxisNum);
        chart.xAxis.ticks = 5;
        chart.yAxis.ticks = 5;
    }
    
    func addChartOverlay(chartOverlay : CLLChartOverlayBars)
    {
        self.chartOverlay = chartOverlay
        self.chartOverlay?.marginBottom = marginBottom
        self.chartOverlay?.marginTop = marginTop
        self.chartOverlay?.marginRight = marginRight
        self.chartOverlay?.marginLeft = marginLeft
        self.chartOverlay?.graphWidth = graphWidth
        self.chartOverlay?.graphHeight = graphHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        chart.drawAxii(self.view)
        
        let delay = 2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.loadData();
        };
        
    }
    
    func loadData()
    {
        self.dataPointArray = normalizePoints(dataPointArray);
        chart.xAxis.scaleFactor = xScaleFactor
        chart.yAxis.scaleFactor = yScaleFactor
        self.chartOverlay?.scale = xScaleFactor
        chart.draw(self.view);
        var line = drawPoints();
        
        if self.chartOverlay != nil
        {
            self.chartOverlay?.drawInView(self.view)
            chart.yLabelView.userInteractionEnabled = false
        }
    }
        
    
    func drawPoints() ->CALayer
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
        return layer;
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
        
        for point: CGPoint in points{
            var xVal :CGFloat = (point.x * xScaleFactor) + self.marginLeft;
            var yVal : CGFloat = self.graphHeight + self.marginTop - ((point.y - yAxisNum) * yScaleFactor); //yVal needs to be the inverse bc of iOS coordinates
            scaledPoints.append(CGPointMake(xVal,yVal));
        }
        
        return scaledPoints;
    }
    
    // we capture the touch move events by overriding touchesMoved method
    
    func touchedGraphAtPoint(point : CGPoint)
    {
        
        //Take the x value and get the corresponding y value;
        var xValue = point.x;
        var yVal : CGFloat = 0;
        for point : CGPoint in dataPointArray
        {
            if(point.x >= xValue)
            {
                yVal = point.y;
                break;
            }
        }
        
        var originalVal = ((self.marginTop + self.graphHeight - yVal) / yScaleFactor) + yAxisNum;
        delegate?.touchedGraph(self, val: originalVal);
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer)
    {
        var point : CGPoint = recognizer.locationInView(self.view)
        
        handleGesture(point)
    }
    
    func handleTap(recognizer:UITapGestureRecognizer)
    {        
        var point : CGPoint = recognizer.locationInView(self.view)
        
        handleGesture(point)
    }
    
    func handleGesture(point : CGPoint)
    {
        touchedGraphAtPoint(point)
        
        var data = chartOverlay?.touchAtPoint(point, view: self.view)
        
        if data != nil
        {
            delegate?.touchedBar(self, data: data!)
        }
    }
    
}

