//
//  ViewController.swift
//  FNKCharts
//
//  Created by Phillip Connaughton on 11/20/14.
//  Copyright (c) 2014 FNK. All rights reserved.
//

import UIKit

protocol FNKChartsViewDelegate {
    func touchedGraph(chart : FNKChartsViewController , val : CGFloat)
    func touchedBar(chart : FNKChartsViewController , data : FNKBarOverlayData)
}

class FNKChartsViewController: UIViewController {
    
    var dataPointArray: Array<CGPoint> = [];
    var marginLeft: CGFloat
    var marginRight: CGFloat
    var marginTop: CGFloat
    var marginBottom: CGFloat
    var graphWidth: CGFloat
    var graphHeight: CGFloat
    
    //Graph variables 
    var xScaleFactor: CGFloat?
    var yScaleFactor: CGFloat?
    var xRange: CGFloat?
    var yRange: CGFloat?
    
    var yPadding : CGFloat;
    var yAxisNum : CGFloat?;
    
    var drawBars : Bool;
    
    var chart: FNKLineChart;
    
    var delegate: FNKChartsViewDelegate?;
    var chartOverlay : FNKChartOverlayBars?
    
    convenience init(frame : CGRect)
    {
        self.init(rect: frame,marginLeft : 10, marginRight : 10, marginTop : 5, marginBottom : 5, graphWidth: 300, graphHeight : 160, yPadding : 0)
    }
    
    init(rect : CGRect, marginLeft : CGFloat, marginRight : CGFloat, marginTop : CGFloat, marginBottom : CGFloat, graphWidth : CGFloat, graphHeight : CGFloat, yPadding : CGFloat)
    {
        self.yPadding = yPadding;
        self.marginLeft = marginLeft
        self.marginRight = marginRight
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
        self.graphWidth = graphWidth;
        self.graphHeight = graphHeight;
        
        self.yPadding = yPadding;
        self.drawBars = false
        
        self.graphWidth = rect.width - self.marginRight - self.marginLeft;
        self.graphHeight = rect.size.height - self.marginTop - self.marginBottom;
        
        chart = FNKLineChart(marginLeft: marginLeft, marginRight: marginRight, marginTop: marginTop, marginBottom: marginBottom, graphWidth: self.graphWidth, graphHeight: self.graphHeight);
        
        super.init(nibName: nil, bundle: nil);
        
        self.view.frame = rect
        
        chart.xAxis.ticks = 5;
        chart.yAxis.ticks = 5;
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var panGesture = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        self.view.addGestureRecognizer(panGesture)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func addChartOverlay(chartOverlay : FNKChartOverlayBars)
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
        chart.yAxis.yAxisNum = yAxisNum!
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
        
        self.xScaleFactor = self.graphWidth / self.xRange!
        self.yScaleFactor = self.graphHeight / self.yRange!
        
        var scaledPoints :Array<CGPoint> = Array();
        
        for point: CGPoint in points{
            var xVal :CGFloat = (point.x * xScaleFactor!) + self.marginLeft;
            var yVal : CGFloat = self.graphHeight + self.marginTop - ((point.y - yAxisNum!) * yScaleFactor!); //yVal needs to be the inverse bc of iOS coordinates
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
        
        var originalVal = ((self.marginTop + self.graphHeight - yVal) / yScaleFactor!) + yAxisNum!;
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

