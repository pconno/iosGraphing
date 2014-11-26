//
//  MainViewController.swift
//  FNKCharts
//
//  Created by Phillip Connaughton on 11/20/14.
//  Copyright (c) 2014 FNK. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ChartsViewDelegate {
    @IBOutlet var paceLabel: UILabel!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var albumImage: UIImageView!
    @IBOutlet var elevationLabel: UILabel!
    
    var paceChartsVC : ChartsViewController!
    var elevationChartsVC : ChartsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        addPaceChart()
        
        addElevationChart()
    }
    
    func addPaceChart()
    {
        paceChartsVC = ChartsViewController(frame: CGRectMake(0, 70, 320, 160));
        paceChartsVC.dataPointArray = addPointsPaceByDistance();
        paceChartsVC.yPadding = 30;
        
        paceChartsVC.addChartOverlay(FNKChartOverlayBars())
        
        //Set custom colors for chart -- Not necessary as all charts will have defaults
        paceChartsVC.chart.yAxis.strokeColor = UIColor.clearColor().CGColor;
        paceChartsVC.chart.yAxis.fillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        paceChartsVC.chart.yAxis.tickFillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        paceChartsVC.chart.yAxis.tickStrokeColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        paceChartsVC.chart.yAxis.tickType = FNKTickType.Behind;
        
        paceChartsVC.chart.xAxis.strokeColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        paceChartsVC.chart.xAxis.fillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        paceChartsVC.chart.xAxis.tickFillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        paceChartsVC.chart.xAxis.tickStrokeColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        
        
        paceChartsVC.chart.lineStrokeColor = UIColor(red: 0.48828125, green: 0.83203125, blue: 0.98828125, alpha: 1.0).CGColor;
        paceChartsVC.chart.yAxis.tickFormat = {
            (arg:Float) -> NSString in
            return self.durationFormat(arg);
        }
        paceChartsVC.chart.xAxis.tickFormat = {
            (arg:Float) -> NSString in
            return self.milesFromMeters(arg);
        }
        
        paceChartsVC.delegate = self;
        
        paceChartsVC.chartOverlay?.dataSet = createMusicDataSet()
        
        self.addChildViewController(paceChartsVC);
        
        self.view.addSubview(paceChartsVC.view);
    }
    
    func addElevationChart()
    {
        elevationChartsVC = ChartsViewController(frame: CGRectMake(0, 320, 320, 160));
//        elevationChartsVC.view.frame = CGRectMake(0, 320, 320, 160);
        elevationChartsVC.dataPointArray = addPointsElevationByDistance();
        elevationChartsVC.yPadding = 0;
        
        elevationChartsVC.chart.yAxis.strokeColor = UIColor.clearColor().CGColor;
        elevationChartsVC.chart.yAxis.fillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        elevationChartsVC.chart.yAxis.tickFillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        elevationChartsVC.chart.yAxis.tickStrokeColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        elevationChartsVC.chart.yAxis.tickType = FNKTickType.Behind;
        
        elevationChartsVC.chart.xAxis.strokeColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        elevationChartsVC.chart.xAxis.fillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        elevationChartsVC.chart.xAxis.tickFillColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        elevationChartsVC.chart.xAxis.tickStrokeColor = UIColor(red: 0.91015625, green: 0.91015625, blue: 0.91015625, alpha: 0.7).CGColor;
        
        
        elevationChartsVC.chart.lineStrokeColor = UIColor(red: 0.6640625, green: 0.875, blue: 0.39453125, alpha: 1.0).CGColor;
        elevationChartsVC.chart.yAxis.tickFormat = {
            (arg:Float) -> NSString in
            return self.elevationFormat(arg);
        }
        elevationChartsVC.chart.xAxis.tickFormat = {
            (arg:Float) -> NSString in
            return self.milesFromMeters(arg);
        }
        
        elevationChartsVC.delegate = self;
        
        self.addChildViewController(elevationChartsVC);
        
        self.view.addSubview(elevationChartsVC.view);
    }
    
    func milesFromMeters(meters : Float) ->NSString
    {
        var miles: Float = meters / 1609.0;
        return NSString(format: "%.1f", miles);
    }
    
    func durationFormat(secs : Float) ->NSString
    {
        var hours = roundf( (secs / (60.0 * 60.0)) );
        var divisor_for_minutes = secs % (60 * 60);
        var minutes = roundf(divisor_for_minutes / 60);
        
        var divisor_for_seconds = divisor_for_minutes % 60;
        var seconds = round(divisor_for_seconds);
        
        if (hours == 0) {
            return NSString(format: "%0.f:%@", minutes, padTime(seconds));
        }
        
        return NSString(format: "%@:%@:%@", padTime(hours), padTime(minutes), padTime(seconds));
    }
    
    func elevationFormat(meters : Float) -> NSString
    {
        return NSString(format: "%.f", (meters / 0.3048));
    }
    
    func padTime(time : Float) ->NSString
    {
        if(time < 10)
        {
            return NSString(format: "0%0.f",time);
        }
        else
        {
            return NSString(format: "%0.f",time);
        }
    }
    
    func touchedGraph(chart : ChartsViewController ,val : CGFloat)
    {
        if(chart.isEqual(paceChartsVC))
        {
            paceLabel.text = self.durationFormat(Float(val));
        }
        else if(chart.isEqual(elevationChartsVC))
        {
            elevationLabel.text = self.elevationFormat(Float(val));
        }
    }
    
    func touchedBar(chart : ChartsViewController , data : FNKBarOverlayData)
    {
        songLabel.text = NSString(format: "%@ - %@", data.data["artist"] as NSString , data.data["title"] as NSString)
        showSong(true)
    }

    func showSong(show : Bool)
    {
        self.songLabel.hidden = !show
        self.albumImage.hidden = !show
    }
    
    func createMusicDataSet() ->NSArray
    {
        var points : NSMutableArray = NSMutableArray();
        
        points.addObject(FNKBarOverlayData(x: 0, data: ["title" : "Wicked Twisted Road", "artist" : "Reckless Kelly"]))
        points.addObject(FNKBarOverlayData(x: 800, data: ["title" : "Texas and Tennese", "artist" : "Lucero"]))
        points.addObject(FNKBarOverlayData(x: 2000, data: ["title" : "7 & 7", "artist" : "Turnpike Troubadors"]))
        points.addObject(FNKBarOverlayData(x: 3000, data: ["title" : "Down on Washington", "artist" : "Turnpike Troubadors"]))
        points.addObject(FNKBarOverlayData(x: 3400, data: ["title" : "1968", "artist" : "Turnpike Troubadors"]))
        points.addObject(FNKBarOverlayData(x: 4000, data: ["title" : "Pompeii", "artist" : "Bastille"]))
        points.addObject(FNKBarOverlayData(x: 5000, data: ["title" : "Happy", "artist" : "Pharrell Williams"]))
        points.addObject(FNKBarOverlayData(x: 5300, data: ["title" : "Shreveport", "artist" : "Turnpike Troubadors"]))
        points.addObject(FNKBarOverlayData(x: 6200, data: ["title" : "Billy Jean", "artist" : "Michael Jackson"]))
        points.addObject(FNKBarOverlayData(x: 7700, data: ["title" : "Diamonds & Gasoline", "artist" : "Turnpike Troubadors"]))
        
        return points
    }
    
    func addPointsPaceByDuration() ->Array<CGPoint>{
        var points :Array<CGPoint> = Array();
        points.append(CGPointMake(11.332000,649.092604));
        points.append(CGPointMake(26.661000,620.929929));
        points.append(CGPointMake(39.489000,597.366982));
        points.append(CGPointMake(46.376000,570.612544));
        points.append(CGPointMake(53.350000,528.623336));
        points.append(CGPointMake(66.602000,425.682068));
        points.append(CGPointMake(72.337000,415.130391));
        points.append(CGPointMake(78.344000,408.683997));
        points.append(CGPointMake(87.561000,413.613021));
        points.append(CGPointMake(92.346000,421.073416));
        points.append(CGPointMake(99.666000,420.133158));
        points.append(CGPointMake(109.671000,443.147187));
        points.append(CGPointMake(115.672000,511.656461));
        points.append(CGPointMake(123.662000,548.700056));
        points.append(CGPointMake(136.325000,550.948349));
        points.append(CGPointMake(142.350000,554.080446));
        points.append(CGPointMake(157.485000,552.730628));
        points.append(CGPointMake(169.350000,541.232301));
        points.append(CGPointMake(176.340000,518.453394));
        points.append(CGPointMake(182.395000,514.923722));
        points.append(CGPointMake(191.714000,456.869326));
        points.append(CGPointMake(198.349000,500.654375));
        points.append(CGPointMake(205.364000,520.636958));
        points.append(CGPointMake(214.647000,509.400148));
        points.append(CGPointMake(221.680000,505.258940));
        points.append(CGPointMake(243.362000,522.326913));
        points.append(CGPointMake(249.402000,522.926506));
        points.append(CGPointMake(255.654000,551.447257));
        points.append(CGPointMake(264.482000,546.574494));
        points.append(CGPointMake(273.569000,489.214273));
        points.append(CGPointMake(280.500000,471.058173));
        points.append(CGPointMake(293.507000,493.174104));
        points.append(CGPointMake(300.440000,498.639444));
        points.append(CGPointMake(308.472000,495.979339));
        points.append(CGPointMake(320.371000,479.728574));
        points.append(CGPointMake(328.466000,468.310495));
        points.append(CGPointMake(334.389000,469.496698));
        points.append(CGPointMake(343.649000,459.548928));
        points.append(CGPointMake(349.347000,467.768119));
        points.append(CGPointMake(358.375000,475.300433));
        points.append(CGPointMake(368.368000,486.618733));
        points.append(CGPointMake(374.412000,488.167009));
        points.append(CGPointMake(382.390000,488.951570));
        points.append(CGPointMake(432.393000,437.529361));
        points.append(CGPointMake(439.472000,437.323349));
        points.append(CGPointMake(446.637000,437.542922));
        points.append(CGPointMake(458.439000,439.271717));
        points.append(CGPointMake(466.303000,438.829393));
        points.append(CGPointMake(472.637000,443.626129));
        points.append(CGPointMake(482.517000,448.949952));
        points.append(CGPointMake(488.504000,445.067076));
        points.append(CGPointMake(494.390000,442.207975));
        points.append(CGPointMake(500.441000,442.247876));
        points.append(CGPointMake(507.380000,443.537591));
        points.append(CGPointMake(518.436000,443.664664));
        points.append(CGPointMake(525.369000,442.822090));
        points.append(CGPointMake(531.576000,442.428932));
        points.append(CGPointMake(540.391000,441.718569));
        points.append(CGPointMake(548.429000,440.846185));
        points.append(CGPointMake(556.408000,440.867370));
        points.append(CGPointMake(567.396000,440.802753));
        points.append(CGPointMake(573.647000,441.495761));
        points.append(CGPointMake(580.665000,441.646294));
        points.append(CGPointMake(589.674000,441.957340));
        points.append(CGPointMake(595.543000,441.632419));
        points.append(CGPointMake(601.456000,441.142541));
        points.append(CGPointMake(610.782000,441.456465));
        points.append(CGPointMake(617.597000,440.144130));
        points.append(CGPointMake(623.406000,438.070586));
        points.append(CGPointMake(634.408000,437.454509));
        points.append(CGPointMake(644.452000,442.304220));
        points.append(CGPointMake(648.516000,442.105524));
        points.append(CGPointMake(657.387000,450.010699));
        points.append(CGPointMake(663.658000,453.776748));
        points.append(CGPointMake(674.457000,451.586561));
        points.append(CGPointMake(680.369000,447.148821));
        points.append(CGPointMake(686.429000,447.994645));
        points.append(CGPointMake(695.528000,448.770624));
        points.append(CGPointMake(701.541000,449.878325));
        points.append(CGPointMake(707.694000,449.250652));
        points.append(CGPointMake(716.411000,444.715276));
        points.append(CGPointMake(722.304000,443.448391));
        points.append(CGPointMake(728.648000,441.381526));
        points.append(CGPointMake(737.450000,439.542290));
        points.append(CGPointMake(744.475000,439.102192));
        points.append(CGPointMake(750.343000,439.802607));
        points.append(CGPointMake(759.367000,441.707271));
        points.append(CGPointMake(766.477000,441.396969));
        points.append(CGPointMake(772.388000,443.122503));
        points.append(CGPointMake(781.418000,443.535575));
        points.append(CGPointMake(789.446000,443.001112));
        points.append(CGPointMake(796.398000,441.441255));
        points.append(CGPointMake(808.433000,435.725062));
        points.append(CGPointMake(816.335000,438.023392));
        points.append(CGPointMake(825.557000,439.634246));
        points.append(CGPointMake(834.387000,440.387171));
        points.append(CGPointMake(839.486000,437.552555));
        points.append(CGPointMake(845.378000,437.953304));
        points.append(CGPointMake(855.466000,439.229090));
        points.append(CGPointMake(862.365000,439.588623));
        points.append(CGPointMake(872.574000,439.413164));
        points.append(CGPointMake(878.702000,440.128926));
        points.append(CGPointMake(884.496000,439.971723));
        points.append(CGPointMake(894.391000,440.129949));
        points.append(CGPointMake(900.402000,439.406116));
        points.append(CGPointMake(905.405000,439.752008));
        points.append(CGPointMake(914.366000,438.935070));
        points.append(CGPointMake(921.382000,439.900512));
        points.append(CGPointMake(927.543000,441.028205));
        points.append(CGPointMake(938.587000,439.784090));
        points.append(CGPointMake(945.699000,442.021769));
        points.append(CGPointMake(951.483000,442.706662));
        points.append(CGPointMake(961.586000,439.365546));
        points.append(CGPointMake(967.715000,435.358406));
        points.append(CGPointMake(974.517000,435.765715));
        points.append(CGPointMake(983.694000,430.242613));
        points.append(CGPointMake(990.670000,430.914875));
        points.append(CGPointMake(996.525000,432.058974));
        points.append(CGPointMake(1005.496000,431.620098));
        points.append(CGPointMake(1012.414000,430.333719));
        points.append(CGPointMake(1019.381000,430.624517));
        points.append(CGPointMake(1028.683000,435.145019));
        points.append(CGPointMake(1035.662000,438.777669));
        points.append(CGPointMake(1041.675000,441.089706));
        points.append(CGPointMake(1050.563000,442.073322));
        points.append(CGPointMake(1058.649000,439.224184));
        points.append(CGPointMake(1067.578000,438.403678));
        points.append(CGPointMake(1073.673000,440.175687));
        points.append(CGPointMake(1079.385000,440.784050));
        points.append(CGPointMake(1089.683000,441.694039));
        points.append(CGPointMake(1095.910000,441.754694));
        points.append(CGPointMake(1102.592000,439.403960));
        points.append(CGPointMake(1113.506000,438.500811));
        points.append(CGPointMake(1118.412000,439.030002));
        points.append(CGPointMake(1124.486000,437.362330));
        points.append(CGPointMake(1133.507000,437.076590));
        points.append(CGPointMake(1139.372000,436.395782));
        points.append(CGPointMake(1146.360000,435.917873));
        points.append(CGPointMake(1156.613000,436.331754));
        points.append(CGPointMake(1163.748000,437.259619));
        points.append(CGPointMake(1168.359000,437.046465));
        points.append(CGPointMake(1178.433000,434.892500));
        points.append(CGPointMake(1189.386000,433.718846));
        points.append(CGPointMake(1197.605000,434.019848));
        points.append(CGPointMake(1207.467000,434.468074));
        points.append(CGPointMake(1213.565000,434.266788));
        points.append(CGPointMake(1219.584000,433.913455));
        points.append(CGPointMake(1226.402000,432.448130));
        points.append(CGPointMake(1233.523000,431.572520));
        points.append(CGPointMake(1240.506000,429.990523));
        points.append(CGPointMake(1249.380000,428.772374));
        points.append(CGPointMake(1256.392000,428.626916));
        points.append(CGPointMake(1265.389000,428.496813));
        points.append(CGPointMake(1271.393000,426.032659));
        points.append(CGPointMake(1277.655000,424.857915));
        points.append(CGPointMake(1287.390000,427.012022));
        points.append(CGPointMake(1293.491000,426.570071));
        points.append(CGPointMake(1299.483000,426.785380));
        points.append(CGPointMake(1308.399000,426.960310));
        points.append(CGPointMake(1314.441000,425.638520));
        points.append(CGPointMake(1321.419000,425.922504));
        points.append(CGPointMake(1330.381000,426.152734));
        points.append(CGPointMake(1336.389000,429.388082));
        points.append(CGPointMake(1342.393000,425.882843));
        points.append(CGPointMake(1351.592000,420.945458));
        points.append(CGPointMake(1358.406000,416.455671));
        points.append(CGPointMake(1364.650000,416.568971));
        points.append(CGPointMake(1373.404000,416.093387));
        points.append(CGPointMake(1379.556000,418.756911));
        points.append(CGPointMake(1385.384000,420.767149));
        points.append(CGPointMake(1394.447000,417.944252));
        points.append(CGPointMake(1400.552000,417.501896));
        points.append(CGPointMake(1406.429000,417.166157));
        points.append(CGPointMake(1415.512000,414.884817));
        points.append(CGPointMake(1421.484000,414.278832));
        points.append(CGPointMake(1430.545000,413.878917));
        points.append(CGPointMake(1436.396000,412.335152));
        points.append(CGPointMake(1442.644000,411.759931));
        points.append(CGPointMake(1451.472000,411.885740));
        points.append(CGPointMake(1457.542000,412.691849));
        points.append(CGPointMake(1463.565000,412.415488));
        points.append(CGPointMake(1473.595000,409.598464));
        points.append(CGPointMake(1479.681000,409.782675));
        points.append(CGPointMake(1485.653000,409.501453));
        points.append(CGPointMake(1494.389000,408.159589));
        points.append(CGPointMake(1500.395000,408.622941));
        points.append(CGPointMake(1506.373000,408.908986));
        points.append(CGPointMake(1515.409000,406.484844));
        points.append(CGPointMake(1521.641000,406.726596));
        points.append(CGPointMake(1527.392000,405.677381));
        points.append(CGPointMake(1536.520000,405.268574));
        points.append(CGPointMake(1542.796000,402.832820));
        points.append(CGPointMake(1548.563000,400.714906));
        points.append(CGPointMake(1557.642000,398.915804));
        points.append(CGPointMake(1563.674000,399.062614));
        points.append(CGPointMake(1569.543000,399.354744));
        points.append(CGPointMake(1578.575000,398.374908));
        points.append(CGPointMake(1584.566000,395.661522));
        points.append(CGPointMake(1590.516000,395.637312));
        points.append(CGPointMake(1599.433000,394.662206));
        points.append(CGPointMake(1606.445000,395.139245));
        points.append(CGPointMake(1615.400000,394.541799));
        points.append(CGPointMake(1621.685000,393.384688));
        points.append(CGPointMake(1627.372000,392.684307));
        points.append(CGPointMake(1636.544000,391.899353));
        points.append(CGPointMake(1642.402000,392.242138));
        points.append(CGPointMake(1648.460000,393.147582));
        points.append(CGPointMake(1657.365000,391.687003));
        points.append(CGPointMake(1663.657000,391.195724));
        points.append(CGPointMake(1669.567000,390.565373));
        points.append(CGPointMake(1678.381000,389.515620));
        points.append(CGPointMake(1684.648000,389.598010));
        points.append(CGPointMake(1690.374000,388.511719));
        points.append(CGPointMake(1698.453000,388.030332));
        points.append(CGPointMake(1703.461000,388.272405));
        points.append(CGPointMake(1709.634000,387.875205));
        points.append(CGPointMake(1718.534000,388.950957));
        points.append(CGPointMake(1724.601000,388.160695));
        points.append(CGPointMake(1730.605000,389.370121));
        points.append(CGPointMake(1738.424000,389.548833));
        points.append(CGPointMake(1744.439000,391.088150));
        points.append(CGPointMake(1750.422000,392.256460));
        points.append(CGPointMake(1759.411000,388.981416));
        points.append(CGPointMake(1765.572000,387.536220));
        points.append(CGPointMake(1772.393000,386.061872));
        points.append(CGPointMake(1781.648000,385.289968));
        points.append(CGPointMake(1787.642000,384.865298));
        points.append(CGPointMake(1796.412000,384.700632));
        points.append(CGPointMake(1802.505000,385.039967));
        points.append(CGPointMake(1808.658000,385.028386));
        points.append(CGPointMake(1817.671000,383.543751));
        points.append(CGPointMake(1823.675000,383.754219));
        points.append(CGPointMake(1829.396000,383.667659));
        points.append(CGPointMake(1839.404000,383.966565));
        points.append(CGPointMake(1845.486000,382.940977));
        points.append(CGPointMake(1851.565000,386.771971));
        points.append(CGPointMake(1860.379000,388.115205));
        points.append(CGPointMake(1867.392000,390.732762));
        points.append(CGPointMake(1873.429000,389.406993));
        points.append(CGPointMake(1881.574000,389.900124));
        points.append(CGPointMake(1888.430000,397.962203));
        points.append(CGPointMake(1894.383000,404.681519));
        points.append(CGPointMake(1903.590000,404.745961));
        points.append(CGPointMake(1909.536000,404.832252));
        points.append(CGPointMake(1912.418000,404.370723));
        points.append(CGPointMake(1920.421000,402.697987));
        points.append(CGPointMake(1925.450000,403.703023));
        points.append(CGPointMake(1931.374000,404.592526));
        points.append(CGPointMake(1939.385000,403.964304));
        points.append(CGPointMake(1945.453000,403.218041));
        points.append(CGPointMake(1954.538000,402.515324));
        points.append(CGPointMake(1960.346000,403.525885));
        points.append(CGPointMake(1966.416000,403.470660));
        points.append(CGPointMake(1975.386000,404.563746));
        points.append(CGPointMake(1981.581000,405.057063));
        points.append(CGPointMake(1987.478000,403.076142));
        points.append(CGPointMake(1996.438000,405.040868));
        points.append(CGPointMake(2002.415000,404.604188));
        points.append(CGPointMake(2010.590000,405.582267));
        points.append(CGPointMake(2019.399000,403.469149));
        points.append(CGPointMake(2025.559000,406.626316));
        points.append(CGPointMake(2031.530000,404.642294));
        points.append(CGPointMake(2102.387000,359.891919));
        points.append(CGPointMake(2108.514000,347.034555));
        points.append(CGPointMake(2117.730000,337.392785));
        points.append(CGPointMake(2122.553000,338.639281));
        points.append(CGPointMake(2126.471000,314.755885));
        points.append(CGPointMake(2132.590000,324.057774));
        points.append(CGPointMake(2137.445000,301.235820));
        points.append(CGPointMake(2143.636000,292.638775));
        points.append(CGPointMake(2153.527000,310.522189));
        points.append(CGPointMake(2156.468000,324.551577));
        points.append(CGPointMake(2160.508000,319.277960));
        points.append(CGPointMake(2170.431000,316.890940));
        points.append(CGPointMake(2176.602000,344.374803));
        points.append(CGPointMake(2185.513000,438.705046));
        points.append(CGPointMake(2193.612000,368.431545));
        points.append(CGPointMake(2203.358000,368.802985));
        points.append(CGPointMake(2220.439000,348.451390));
        points.append(CGPointMake(2227.415000,373.827987));
        points.append(CGPointMake(2233.665000,381.699838));
        points.append(CGPointMake(2240.638000,281.534624));
        points.append(CGPointMake(2249.538000,260.864250));
        points.append(CGPointMake(2256.529000,326.366205));
        points.append(CGPointMake(2264.658000,312.469985));
        points.append(CGPointMake(2269.379000,309.354133));
        points.append(CGPointMake(2276.455000,300.156521));
        points.append(CGPointMake(2283.628000,433.849210));
        points.append(CGPointMake(2289.685000,462.880365));
        points.append(CGPointMake(2295.528000,481.063257));
        points.append(CGPointMake(2314.381000,521.594813));
        points.append(CGPointMake(2321.450000,535.833009));
        points.append(CGPointMake(2330.627000,540.046100));
        points.append(CGPointMake(2342.437000,438.060678));
        points.append(CGPointMake(2348.621000,393.129118));
        points.append(CGPointMake(2354.573000,350.610571));
        points.append(CGPointMake(2360.392000,289.484548));
        points.append(CGPointMake(2364.363000,268.725668));
        
        
        return points;
    }
    
    func addPointsPaceByDistance() ->Array<CGPoint>{
            var points :Array<CGPoint> = Array();
        points.append(CGPointMake(32.328132,649.092604));
        points.append(CGPointMake(55.439374,620.929929));
        points.append(CGPointMake(94.482162,597.366982));
        points.append(CGPointMake(117.932410,570.612544));
        points.append(CGPointMake(142.647764,528.623336));
        points.append(CGPointMake(178.420817,425.682068));
        points.append(CGPointMake(205.253506,415.130391));
        points.append(CGPointMake(231.332928,408.683997));
        points.append(CGPointMake(269.416931,413.613021));
        points.append(CGPointMake(292.264987,421.073416));
        points.append(CGPointMake(317.020807,420.133158));
        points.append(CGPointMake(352.254452,443.147187));
        points.append(CGPointMake(372.945204,511.656461));
        points.append(CGPointMake(395.850211,548.700056));
        points.append(CGPointMake(428.927901,550.948349));
        points.append(CGPointMake(451.667712,554.080446));
        points.append(CGPointMake(472.246238,552.730628));
        points.append(CGPointMake(506.920782,541.232301));
        points.append(CGPointMake(529.823227,518.453394));
        points.append(CGPointMake(552.028509,514.923722));
        points.append(CGPointMake(583.733093,456.869326));
        points.append(CGPointMake(607.776146,500.654375));
        points.append(CGPointMake(632.820329,520.636958));
        points.append(CGPointMake(664.778325,509.400148));
        points.append(CGPointMake(687.912988,505.258940));
        points.append(CGPointMake(720.731647,522.326913));
        points.append(CGPointMake(745.550943,522.926506));
        points.append(CGPointMake(772.070089,551.447257));
        points.append(CGPointMake(805.986570,546.574494));
        points.append(CGPointMake(828.663178,489.214273));
        points.append(CGPointMake(851.284809,471.058173));
        points.append(CGPointMake(885.219121,493.174104));
        points.append(CGPointMake(909.721876,498.639444));
        points.append(CGPointMake(935.627585,495.979339));
        points.append(CGPointMake(970.941543,479.728574));
        points.append(CGPointMake(997.351379,468.310495));
        points.append(CGPointMake(1018.866069,469.496698));
        points.append(CGPointMake(1049.680148,459.548928));
        points.append(CGPointMake(1071.965904,467.768119));
        points.append(CGPointMake(1094.689012,475.300433));
        points.append(CGPointMake(1131.069385,486.618733));
        points.append(CGPointMake(1153.881151,488.167009));
        points.append(CGPointMake(1175.585998,488.951570));
        points.append(CGPointMake(1200.088723,437.529361));
        points.append(CGPointMake(1223.341469,437.323349));
        points.append(CGPointMake(1249.977279,437.542922));
        points.append(CGPointMake(1285.687119,439.271717));
        points.append(CGPointMake(1311.577597,438.829393));
        points.append(CGPointMake(1340.556708,443.626129));
        points.append(CGPointMake(1376.362103,448.949952));
        points.append(CGPointMake(1399.031833,445.067076));
        points.append(CGPointMake(1432.326082,442.207975));
        points.append(CGPointMake(1454.103017,442.247876));
        points.append(CGPointMake(1477.440642,443.537591));
        points.append(CGPointMake(1513.552065,443.664664));
        points.append(CGPointMake(1537.207915,442.822090));
        points.append(CGPointMake(1560.178856,442.428932));
        points.append(CGPointMake(1595.032430,441.718569));
        points.append(CGPointMake(1618.993214,440.846185));
        points.append(CGPointMake(1642.931749,440.867370));
        points.append(CGPointMake(1676.263796,440.802753));
        points.append(CGPointMake(1700.553484,441.495761));
        points.append(CGPointMake(1723.603478,441.646294));
        points.append(CGPointMake(1762.736343,441.957340));
        points.append(CGPointMake(1787.881577,441.632419));
        points.append(CGPointMake(1808.804446,441.142541));
        points.append(CGPointMake(1843.539172,441.456465));
        points.append(CGPointMake(1866.150591,440.144130));
        points.append(CGPointMake(1887.440673,438.070586));
        points.append(CGPointMake(1920.250001,437.454509));
        points.append(CGPointMake(1944.099400,442.304220));
        points.append(CGPointMake(1965.165899,442.105524));
        points.append(CGPointMake(2005.760685,450.010699));
        points.append(CGPointMake(2029.188189,453.776748));
        points.append(CGPointMake(2065.711184,451.586561));
        points.append(CGPointMake(2088.106909,447.148821));
        points.append(CGPointMake(2110.310791,447.994645));
        points.append(CGPointMake(2144.558278,448.770624));
        points.append(CGPointMake(2167.558600,449.878325));
        points.append(CGPointMake(2191.089352,449.250652));
        points.append(CGPointMake(2224.179941,444.715276));
        points.append(CGPointMake(2246.959249,443.448391));
        points.append(CGPointMake(2267.943068,441.381526));
        points.append(CGPointMake(2299.016788,439.542290));
        points.append(CGPointMake(2323.170156,439.102192));
        points.append(CGPointMake(2346.015290,439.802607));
        points.append(CGPointMake(2380.242174,441.707271));
        points.append(CGPointMake(2404.497734,441.396969));
        points.append(CGPointMake(2427.451209,443.122503));
        points.append(CGPointMake(2460.172826,443.535575));
        points.append(CGPointMake(2485.851233,443.001112));
        points.append(CGPointMake(2511.158199,441.441255));
        points.append(CGPointMake(2549.441503,435.725062));
        points.append(CGPointMake(2571.235275,438.023392));
        points.append(CGPointMake(2594.799133,439.634246));
        points.append(CGPointMake(2628.909271,440.387171));
        points.append(CGPointMake(2652.268250,437.552555));
        points.append(CGPointMake(2677.293197,437.953304));
        points.append(CGPointMake(2710.282021,439.229090));
        points.append(CGPointMake(2732.310253,439.588623));
        points.append(CGPointMake(2773.271786,439.413164));
        points.append(CGPointMake(2797.179204,440.128926));
        points.append(CGPointMake(2822.391146,439.971723));
        points.append(CGPointMake(2858.054428,440.129949));
        points.append(CGPointMake(2882.412998,439.406116));
        points.append(CGPointMake(2903.617628,439.752008));
        points.append(CGPointMake(2938.175051,438.935070));
        points.append(CGPointMake(2962.831681,439.900512));
        points.append(CGPointMake(2985.821346,441.028205));
        points.append(CGPointMake(3021.936469,439.784090));
        points.append(CGPointMake(3045.804364,442.021769));
        points.append(CGPointMake(3067.790537,442.706662));
        points.append(CGPointMake(3102.212054,439.365546));
        points.append(CGPointMake(3127.349435,435.358406));
        points.append(CGPointMake(3153.212166,435.765715));
        points.append(CGPointMake(3187.764020,430.242613));
        points.append(CGPointMake(3211.852064,430.914875));
        points.append(CGPointMake(3236.367116,432.058974));
        points.append(CGPointMake(3272.031707,431.620098));
        points.append(CGPointMake(3295.854648,430.333719));
        points.append(CGPointMake(3318.736155,430.624517));
        points.append(CGPointMake(3355.031685,435.145019));
        points.append(CGPointMake(3379.596841,438.777669));
        points.append(CGPointMake(3402.759590,441.089706));
        points.append(CGPointMake(3437.344729,442.073322));
        points.append(CGPointMake(3464.807558,439.224184));
        points.append(CGPointMake(3496.851520,438.403678));
        points.append(CGPointMake(3518.816805,440.175687));
        points.append(CGPointMake(3541.138174,440.784050));
        points.append(CGPointMake(3575.235156,441.694039));
        points.append(CGPointMake(3597.308243,441.754694));
        points.append(CGPointMake(3620.531004,439.403960));
        points.append(CGPointMake(3656.342846,438.500811));
        points.append(CGPointMake(3678.817346,439.030002));
        points.append(CGPointMake(3704.641892,437.362330));
        points.append(CGPointMake(3737.532127,437.076590));
        points.append(CGPointMake(3760.513575,436.395782));
        points.append(CGPointMake(3784.233918,435.917873));
        points.append(CGPointMake(3818.182158,436.331754));
        points.append(CGPointMake(3845.519020,437.259619));
        points.append(CGPointMake(3870.284617,437.046465));
        points.append(CGPointMake(3905.259471,434.892500));
        points.append(CGPointMake(3930.181533,433.718846));
        points.append(CGPointMake(3951.534164,434.019848));
        points.append(CGPointMake(3986.331199,434.468074));
        points.append(CGPointMake(4009.389244,434.266788));
        points.append(CGPointMake(4033.336718,433.913455));
        points.append(CGPointMake(4070.565060,432.448130));
        points.append(CGPointMake(4093.005287,431.572520));
        points.append(CGPointMake(4116.477958,429.990523));
        points.append(CGPointMake(4149.055073,428.772374));
        points.append(CGPointMake(4173.128941,428.626916));
        points.append(CGPointMake(4206.653228,428.496813));
        points.append(CGPointMake(4230.165030,426.032659));
        points.append(CGPointMake(4254.272226,424.857915));
        points.append(CGPointMake(4290.089215,427.012022));
        points.append(CGPointMake(4314.891010,426.570071));
        points.append(CGPointMake(4339.024218,426.785380));
        points.append(CGPointMake(4374.495170,426.960310));
        points.append(CGPointMake(4396.162153,425.638520));
        points.append(CGPointMake(4420.960966,425.922504));
        points.append(CGPointMake(4456.490689,426.152734));
        points.append(CGPointMake(4478.561319,429.388082));
        points.append(CGPointMake(4504.003877,425.882843));
        points.append(CGPointMake(4540.792942,420.945458));
        points.append(CGPointMake(4563.127655,416.455671));
        points.append(CGPointMake(4588.336840,416.568971));
        points.append(CGPointMake(4622.006573,416.093387));
        points.append(CGPointMake(4646.526777,418.756911));
        points.append(CGPointMake(4670.611910,420.767149));
        points.append(CGPointMake(4708.166459,417.944252));
        points.append(CGPointMake(4730.508466,417.501896));
        points.append(CGPointMake(4753.169545,417.166157));
        points.append(CGPointMake(4787.386187,414.884817));
        points.append(CGPointMake(4811.221824,414.278832));
        points.append(CGPointMake(4844.001553,413.878917));
        points.append(CGPointMake(4867.301507,412.335152));
        points.append(CGPointMake(4890.601431,411.759931));
        points.append(CGPointMake(4926.234690,411.885740));
        points.append(CGPointMake(4949.383689,412.691849));
        points.append(CGPointMake(4970.065991,412.415488));
        points.append(CGPointMake(5005.603809,409.598464));
        points.append(CGPointMake(5028.756520,409.782675));
        points.append(CGPointMake(5051.433143,409.501453));
        points.append(CGPointMake(5086.244257,408.159589));
        points.append(CGPointMake(5107.521351,408.622941));
        points.append(CGPointMake(5130.916376,408.908986));
        points.append(CGPointMake(5165.172465,406.484844));
        points.append(CGPointMake(5187.644717,406.726596));
        points.append(CGPointMake(5211.243261,405.677381));
        points.append(CGPointMake(5243.374359,405.268574));
        points.append(CGPointMake(5267.027470,402.832820));
        points.append(CGPointMake(5291.305005,400.714906));
        points.append(CGPointMake(5327.682569,398.915804));
        points.append(CGPointMake(5352.355079,399.062614));
        points.append(CGPointMake(5376.384903,399.354744));
        points.append(CGPointMake(5412.215042,398.374908));
        points.append(CGPointMake(5435.484862,395.661522));
        points.append(CGPointMake(5460.858314,395.637312));
        points.append(CGPointMake(5498.970605,394.662206));
        points.append(CGPointMake(5524.179423,395.139245));
        points.append(CGPointMake(5560.720722,394.541799));
        points.append(CGPointMake(5587.367226,393.384688));
        points.append(CGPointMake(5611.225095,392.684307));
        points.append(CGPointMake(5647.801552,391.899353));
        points.append(CGPointMake(5673.332933,392.242138));
        points.append(CGPointMake(5697.147738,393.147582));
        points.append(CGPointMake(5732.567406,391.687003));
        points.append(CGPointMake(5757.524897,391.195724));
        points.append(CGPointMake(5783.107062,390.565373));
        points.append(CGPointMake(5820.539417,389.515620));
        points.append(CGPointMake(5846.836179,389.598010));
        points.append(CGPointMake(5871.765078,388.511719));
        points.append(CGPointMake(5916.054663,388.030332));
        points.append(CGPointMake(5940.497693,388.272405));
        points.append(CGPointMake(5963.987452,387.875205));
        points.append(CGPointMake(5996.843478,388.950957));
        points.append(CGPointMake(6022.995358,388.160695));
        points.append(CGPointMake(6050.073993,389.370121));
        points.append(CGPointMake(6084.709066,389.548833));
        points.append(CGPointMake(6109.493818,391.088150));
        points.append(CGPointMake(6133.457981,392.256460));
        points.append(CGPointMake(6167.709209,388.981416));
        points.append(CGPointMake(6191.654976,387.536220));
        points.append(CGPointMake(6219.033644,386.061872));
        points.append(CGPointMake(6256.872549,385.289968));
        points.append(CGPointMake(6278.714570,384.865298));
        points.append(CGPointMake(6310.998326,384.700632));
        points.append(CGPointMake(6335.141092,385.039967));
        points.append(CGPointMake(6361.920248,385.028386));
        points.append(CGPointMake(6399.503571,383.543751));
        points.append(CGPointMake(6424.312735,383.754219));
        points.append(CGPointMake(6448.425153,383.667659));
        points.append(CGPointMake(6486.541771,383.966565));
        points.append(CGPointMake(6511.761537,382.940977));
        points.append(CGPointMake(6535.755330,386.771971));
        points.append(CGPointMake(6571.959567,388.115205));
        points.append(CGPointMake(6596.349344,390.732762));
        points.append(CGPointMake(6621.507716,389.406993));
        points.append(CGPointMake(6653.366501,389.900124));
        points.append(CGPointMake(6680.647138,397.962203));
        points.append(CGPointMake(6701.945476,404.681519));
        points.append(CGPointMake(6734.842506,404.745961));
        points.append(CGPointMake(6758.779916,404.832252));
        points.append(CGPointMake(6782.709946,404.370723));
        points.append(CGPointMake(6820.600434,402.697987));
        points.append(CGPointMake(6845.087414,403.703023));
        points.append(CGPointMake(6867.316896,404.592526));
        points.append(CGPointMake(6903.770976,403.964304));
        points.append(CGPointMake(6926.032462,403.218041));
        points.append(CGPointMake(6962.668828,402.515324));
        points.append(CGPointMake(6989.857186,403.525885));
        points.append(CGPointMake(7014.690468,403.470660));
        points.append(CGPointMake(7053.541438,404.563746));
        points.append(CGPointMake(7079.921826,405.057063));
        points.append(CGPointMake(7105.932120,403.076142));
        points.append(CGPointMake(7145.689551,405.040868));
        points.append(CGPointMake(7170.349024,404.604188));
        points.append(CGPointMake(7191.879583,405.582267));
        points.append(CGPointMake(7229.471082,403.469149));
        points.append(CGPointMake(7253.216088,406.626316));
        points.append(CGPointMake(7275.855838,404.642294));
        points.append(CGPointMake(7330.393203,359.891919));
        points.append(CGPointMake(7353.530680,347.034555));
        points.append(CGPointMake(7395.387132,337.392785));
        points.append(CGPointMake(7421.459854,338.639281));
        points.append(CGPointMake(7443.470421,314.755885));
        points.append(CGPointMake(7476.249515,324.057774));
        points.append(CGPointMake(7498.739040,301.235820));
        points.append(CGPointMake(7524.507905,292.638775));
        points.append(CGPointMake(7561.278892,310.522189));
        points.append(CGPointMake(7587.839009,324.551577));
        points.append(CGPointMake(7619.312545,319.277960));
        points.append(CGPointMake(7661.522146,316.890940));
        points.append(CGPointMake(7684.900410,344.374803));
        points.append(CGPointMake(7725.143229,438.705046));
        points.append(CGPointMake(7758.573658,368.431545));
        points.append(CGPointMake(7785.266992,368.802985));
        points.append(CGPointMake(7825.930608,348.451390));
        points.append(CGPointMake(7895.310450,373.827987));
        points.append(CGPointMake(7924.273355,381.699838));
        points.append(CGPointMake(7963.904465,281.534624));
        points.append(CGPointMake(7988.133746,260.864250));
        points.append(CGPointMake(8011.443576,326.366205));
        points.append(CGPointMake(8080.622759,312.469985));
        points.append(CGPointMake(8102.968193,309.354133));
        points.append(CGPointMake(8126.988265,300.156521));
        points.append(CGPointMake(8168.134679,433.849210));
        points.append(CGPointMake(8192.783575,462.880365));
        points.append(CGPointMake(8218.568141,481.063257));
        points.append(CGPointMake(8249.879053,521.594813));
        points.append(CGPointMake(8271.641812,535.833009));
        points.append(CGPointMake(8293.923030,540.046100));
        points.append(CGPointMake(8329.755630,438.060678));
        points.append(CGPointMake(8354.062829,393.129118));
        points.append(CGPointMake(8377.109253,350.610571));
        points.append(CGPointMake(8415.966958,289.484548));
        points.append(CGPointMake(8441.897111,268.725668));
        
        return points;
    }
    
    func addPointsElevationByDistance() ->Array<CGPoint>{
        var points :Array<CGPoint> = Array();

        points.append(CGPointMake(32.328132,5.191463));
        points.append(CGPointMake(55.439374,5.096822));
        points.append(CGPointMake(94.482162,4.666783));
        points.append(CGPointMake(117.932410,4.422490));
        points.append(CGPointMake(142.647764,4.184259));
        points.append(CGPointMake(178.420817,3.944357));
        points.append(CGPointMake(205.253506,3.849256));
        points.append(CGPointMake(231.332928,3.812946));
        points.append(CGPointMake(269.416931,3.382082));
        points.append(CGPointMake(292.264987,3.115525));
        points.append(CGPointMake(317.020807,2.979430));
        points.append(CGPointMake(352.254452,2.819335));
        points.append(CGPointMake(372.945204,2.956084));
        points.append(CGPointMake(395.850211,3.447964));
        points.append(CGPointMake(428.927901,3.821796));
        points.append(CGPointMake(451.667712,3.847947));
        points.append(CGPointMake(472.246238,3.797812));
        points.append(CGPointMake(506.920782,3.467428));
        points.append(CGPointMake(529.823227,3.279213));
        points.append(CGPointMake(552.028509,2.922146));
        points.append(CGPointMake(583.733093,2.427320));
        points.append(CGPointMake(607.776146,1.527787));
        points.append(CGPointMake(632.820329,0.334638));
        points.append(CGPointMake(664.778325,-0.244283));
        points.append(CGPointMake(687.912988,-0.255894));
        points.append(CGPointMake(720.731647,-0.568765));
        points.append(CGPointMake(745.550943,-0.895401));
        points.append(CGPointMake(772.070089,-1.879468));
        points.append(CGPointMake(805.986570,-3.854260));
        points.append(CGPointMake(828.663178,-5.034638));
        points.append(CGPointMake(851.284809,-5.997782));
        points.append(CGPointMake(885.219121,-6.722005));
        points.append(CGPointMake(909.721876,-7.161200));
        points.append(CGPointMake(935.627585,-6.985322));
        points.append(CGPointMake(970.941543,-5.475962));
        points.append(CGPointMake(997.351379,-3.996580));
        points.append(CGPointMake(1018.866069,-2.166902));
        points.append(CGPointMake(1049.680148,0.513493));
        points.append(CGPointMake(1071.965904,1.185427));
        points.append(CGPointMake(1094.689012,1.252019));
        points.append(CGPointMake(1131.069385,1.346690));
        points.append(CGPointMake(1153.881151,1.304718));
        points.append(CGPointMake(1175.585998,1.096026));
        points.append(CGPointMake(1200.088723,2.441433));
        points.append(CGPointMake(1223.341469,2.414601));
        points.append(CGPointMake(1249.977279,2.200938));
        points.append(CGPointMake(1285.687119,2.108372));
        points.append(CGPointMake(1311.577597,1.782273));
        points.append(CGPointMake(1340.556708,1.416775));
        points.append(CGPointMake(1376.362103,1.356086));
        points.append(CGPointMake(1399.031833,1.665818));
        points.append(CGPointMake(1432.326082,2.392153));
        points.append(CGPointMake(1454.103017,3.082335));
        points.append(CGPointMake(1477.440642,3.787350));
        points.append(CGPointMake(1513.552065,4.591751));
        points.append(CGPointMake(1537.207915,4.901993));
        points.append(CGPointMake(1560.178856,5.119728));
        points.append(CGPointMake(1595.032430,5.200028));
        points.append(CGPointMake(1618.993214,5.071152));
        points.append(CGPointMake(1642.931749,4.892508));
        points.append(CGPointMake(1676.263796,4.536520));
        points.append(CGPointMake(1700.553484,4.226520));
        points.append(CGPointMake(1723.603478,3.925467));
        points.append(CGPointMake(1762.736343,3.184858));
        points.append(CGPointMake(1787.881577,2.660555));
        points.append(CGPointMake(1808.804446,2.181096));
        points.append(CGPointMake(1843.539172,1.707641));
        points.append(CGPointMake(1866.150591,1.373534));
        points.append(CGPointMake(1887.440673,1.766121));
        points.append(CGPointMake(1920.250001,2.153081));
        points.append(CGPointMake(1944.099400,2.341557));
        points.append(CGPointMake(1965.165899,2.428976));
        points.append(CGPointMake(2005.760685,2.313822));
        points.append(CGPointMake(2029.188189,2.102569));
        points.append(CGPointMake(2065.711184,1.839044));
        points.append(CGPointMake(2088.106909,1.518340));
        points.append(CGPointMake(2110.310791,1.496545));
        points.append(CGPointMake(2144.558278,0.927489));
        points.append(CGPointMake(2167.558600,0.395504));
        points.append(CGPointMake(2191.089352,-0.014916));
        points.append(CGPointMake(2224.179941,-0.502209));
        points.append(CGPointMake(2246.959249,-0.638346));
        points.append(CGPointMake(2267.943068,-0.503197));
        points.append(CGPointMake(2299.016788,-0.026582));
        points.append(CGPointMake(2323.170156,0.075228));
        points.append(CGPointMake(2346.015290,-0.109057));
        points.append(CGPointMake(2380.242174,-0.494033));
        points.append(CGPointMake(2404.497734,-0.945042));
        points.append(CGPointMake(2427.451209,-1.576414));
        points.append(CGPointMake(2460.172826,-2.397160));
        points.append(CGPointMake(2485.851233,-2.510738));
        points.append(CGPointMake(2511.158199,-2.511637));
        points.append(CGPointMake(2549.441503,-2.233985));
        points.append(CGPointMake(2571.235275,-1.823981));
        points.append(CGPointMake(2594.799133,-1.597655));
        points.append(CGPointMake(2628.909271,-2.004207));
        points.append(CGPointMake(2652.268250,-2.048116));
        points.append(CGPointMake(2677.293197,-2.110819));
        points.append(CGPointMake(2710.282021,-1.984798));
        points.append(CGPointMake(2732.310253,-1.501580));
        points.append(CGPointMake(2773.271786,-1.205182));
        points.append(CGPointMake(2797.179204,-1.868742));
        points.append(CGPointMake(2822.391146,-2.374776));
        points.append(CGPointMake(2858.054428,-3.645745));
        points.append(CGPointMake(2882.412998,-4.540126));
        points.append(CGPointMake(2903.617628,-5.004981));
        points.append(CGPointMake(2938.175051,-5.376846));
        points.append(CGPointMake(2962.831681,-5.445180));
        points.append(CGPointMake(2985.821346,-4.811042));
        points.append(CGPointMake(3021.936469,-3.439579));
        points.append(CGPointMake(3045.804364,-2.038437));
        points.append(CGPointMake(3067.790537,-0.533343));
        points.append(CGPointMake(3102.212054,1.072295));
        points.append(CGPointMake(3127.349435,1.429198));
        points.append(CGPointMake(3153.212166,1.299265));
        points.append(CGPointMake(3187.764020,0.255489));
        points.append(CGPointMake(3211.852064,-0.465214));
        points.append(CGPointMake(3236.367116,-1.014067));
        points.append(CGPointMake(3272.031707,-1.158795));
        points.append(CGPointMake(3295.854648,-0.902051));
        points.append(CGPointMake(3318.736155,-0.558495));
        points.append(CGPointMake(3355.031685,-0.394227));
        points.append(CGPointMake(3379.596841,-0.320269));
        points.append(CGPointMake(3402.759590,-0.169293));
        points.append(CGPointMake(3437.344729,-0.257694));
        points.append(CGPointMake(3464.807558,-0.288528));
        points.append(CGPointMake(3496.851520,0.269658));
        points.append(CGPointMake(3518.816805,0.351736));
        points.append(CGPointMake(3541.138174,0.508724));
        points.append(CGPointMake(3575.235156,1.178591));
        points.append(CGPointMake(3597.308243,1.302539));
        points.append(CGPointMake(3620.531004,1.222378));
        points.append(CGPointMake(3656.342846,0.694468));
        points.append(CGPointMake(3678.817346,0.210143));
        points.append(CGPointMake(3704.641892,-0.397071));
        points.append(CGPointMake(3737.532127,-0.563747));
        points.append(CGPointMake(3760.513575,-0.207202));
        points.append(CGPointMake(3784.233918,0.190925));
        points.append(CGPointMake(3818.182158,0.920556));
        points.append(CGPointMake(3845.519020,1.303491));
        points.append(CGPointMake(3870.284617,1.142885));
        points.append(CGPointMake(3905.259471,0.843352));
        points.append(CGPointMake(3930.181533,0.564646));
        points.append(CGPointMake(3951.534164,0.263058));
        points.append(CGPointMake(3986.331199,0.111044));
        points.append(CGPointMake(4009.389244,0.429331));
        points.append(CGPointMake(4033.336718,0.496595));
        points.append(CGPointMake(4070.565060,0.744952));
        points.append(CGPointMake(4093.005287,1.049124));
        points.append(CGPointMake(4116.477958,1.579089));
        points.append(CGPointMake(4149.055073,2.016764));
        points.append(CGPointMake(4173.128941,2.426293));
        points.append(CGPointMake(4206.653228,3.205937));
        points.append(CGPointMake(4230.165030,3.342426));
        points.append(CGPointMake(4254.272226,3.408480));
        points.append(CGPointMake(4290.089215,3.661823));
        points.append(CGPointMake(4314.891010,3.522654));
        points.append(CGPointMake(4339.024218,3.440026));
        points.append(CGPointMake(4374.495170,3.373132));
        points.append(CGPointMake(4396.162153,3.194496));
        points.append(CGPointMake(4420.960966,2.893931));
        points.append(CGPointMake(4456.490689,2.489939));
        points.append(CGPointMake(4478.561319,1.944573));
        points.append(CGPointMake(4504.003877,1.440587));
        points.append(CGPointMake(4540.792942,0.904143));
        points.append(CGPointMake(4563.127655,0.589260));
        points.append(CGPointMake(4588.336840,0.355543));
        points.append(CGPointMake(4622.006573,0.134970));
        points.append(CGPointMake(4646.526777,0.124275));
        points.append(CGPointMake(4670.611910,0.116743));
        points.append(CGPointMake(4708.166459,-0.091093));
        points.append(CGPointMake(4730.508466,0.074295));
        points.append(CGPointMake(4753.169545,0.165424));
        points.append(CGPointMake(4787.386187,-0.319082));
        points.append(CGPointMake(4811.221824,-0.363643));
        points.append(CGPointMake(4844.001553,-1.141034));
        points.append(CGPointMake(4867.301507,-2.355475));
        points.append(CGPointMake(4890.601431,-3.064898));
        points.append(CGPointMake(4926.234690,-2.488293));
        points.append(CGPointMake(4949.383689,-2.926296));
        points.append(CGPointMake(4970.065991,-2.536159));
        points.append(CGPointMake(5005.603809,-1.290001));
        points.append(CGPointMake(5028.756520,-1.485508));
        points.append(CGPointMake(5051.433143,-2.308825));
        points.append(CGPointMake(5086.244257,-3.004676));
        points.append(CGPointMake(5107.521351,-3.158129));
        points.append(CGPointMake(5130.916376,-2.776951));
        points.append(CGPointMake(5165.172465,-1.979846));
        points.append(CGPointMake(5187.644717,-1.005791));
        points.append(CGPointMake(5211.243261,0.058859));
        points.append(CGPointMake(5243.374359,0.911193));
        points.append(CGPointMake(5267.027470,1.067964));
        points.append(CGPointMake(5291.305005,1.256485));
        points.append(CGPointMake(5327.682569,1.153769));
        points.append(CGPointMake(5352.355079,0.666065));
        points.append(CGPointMake(5376.384903,0.210151));
        points.append(CGPointMake(5412.215042,-0.517435));
        points.append(CGPointMake(5435.484862,-0.633993));
        points.append(CGPointMake(5460.858314,-0.485022));
        points.append(CGPointMake(5498.970605,-0.158457));
        points.append(CGPointMake(5524.179423,0.020945));
        points.append(CGPointMake(5560.720722,0.016315));
        points.append(CGPointMake(5587.367226,-0.286883));
        points.append(CGPointMake(5611.225095,-0.544992));
        points.append(CGPointMake(5647.801552,-1.325507));
        points.append(CGPointMake(5673.332933,-2.089304));
        points.append(CGPointMake(5697.147738,-2.476217));
        points.append(CGPointMake(5732.567406,-2.929092));
        points.append(CGPointMake(5757.524897,-3.036772));
        points.append(CGPointMake(5783.107062,-2.527422));
        points.append(CGPointMake(5820.539417,-1.316097));
        points.append(CGPointMake(5846.836179,-0.568480));
        points.append(CGPointMake(5871.765078,0.085357));
        points.append(CGPointMake(5916.054663,0.785105));
        points.append(CGPointMake(5940.497693,0.869095));
        points.append(CGPointMake(5963.987452,0.680141));
        points.append(CGPointMake(5996.843478,0.600160));
        points.append(CGPointMake(6022.995358,0.631080));
        points.append(CGPointMake(6050.073993,0.530084));
        points.append(CGPointMake(6084.709066,0.747838));
        points.append(CGPointMake(6109.493818,0.809447));
        points.append(CGPointMake(6133.457981,0.883205));
        points.append(CGPointMake(6167.709209,0.579139));
        points.append(CGPointMake(6191.654976,0.528272));
        points.append(CGPointMake(6219.033644,0.451445));
        points.append(CGPointMake(6256.872549,0.492106));
        points.append(CGPointMake(6278.714570,0.842132));
        points.append(CGPointMake(6310.998326,1.497430));
        points.append(CGPointMake(6335.141092,1.907256));
        points.append(CGPointMake(6361.920248,2.217439));
        points.append(CGPointMake(6399.503571,2.240616));
        points.append(CGPointMake(6424.312735,2.137972));
        points.append(CGPointMake(6448.425153,1.877058));
        points.append(CGPointMake(6486.541771,1.516900));
        points.append(CGPointMake(6511.761537,1.144955));
        points.append(CGPointMake(6535.755330,0.997347));
        points.append(CGPointMake(6571.959567,1.151477));
        points.append(CGPointMake(6596.349344,1.663332));
        points.append(CGPointMake(6621.507716,2.105357));
        points.append(CGPointMake(6653.366501,2.569388));
        points.append(CGPointMake(6680.647138,2.781171));
        points.append(CGPointMake(6701.945476,2.767852));
        points.append(CGPointMake(6734.842506,2.487773));
        points.append(CGPointMake(6758.779916,2.537469));
        points.append(CGPointMake(6782.709946,3.043448));
        points.append(CGPointMake(6820.600434,3.531918));
        points.append(CGPointMake(6845.087414,3.427362));
        points.append(CGPointMake(6867.316896,3.189804));
        points.append(CGPointMake(6903.770976,2.545445));
        points.append(CGPointMake(6926.032462,2.444271));
        points.append(CGPointMake(6962.668828,2.772959));
        points.append(CGPointMake(6989.857186,3.144278));
        points.append(CGPointMake(7014.690468,3.225002));
        points.append(CGPointMake(7053.541438,4.064341));
        points.append(CGPointMake(7079.921826,4.130581));
        points.append(CGPointMake(7105.932120,4.185346));
        points.append(CGPointMake(7145.689551,4.030325));
        points.append(CGPointMake(7170.349024,3.508239));
        points.append(CGPointMake(7191.879583,2.902412));
        points.append(CGPointMake(7229.471082,2.569773));
        points.append(CGPointMake(7253.216088,2.378686));
        points.append(CGPointMake(7275.855838,2.495949));
        points.append(CGPointMake(7330.393203,5.022320));
        points.append(CGPointMake(7353.530680,4.967141));
        points.append(CGPointMake(7395.387132,4.893828));
        points.append(CGPointMake(7421.459854,4.794502));
        points.append(CGPointMake(7443.470421,4.731572));
        points.append(CGPointMake(7476.249515,5.022038));
        points.append(CGPointMake(7498.739040,5.400784));
        points.append(CGPointMake(7524.507905,5.822564));
        points.append(CGPointMake(7561.278892,6.320153));
        points.append(CGPointMake(7587.839009,6.550619));
        points.append(CGPointMake(7619.312545,6.435854));
        points.append(CGPointMake(7661.522146,5.872552));
        points.append(CGPointMake(7684.900410,5.517408));
        points.append(CGPointMake(7725.143229,5.109083));
        points.append(CGPointMake(7758.573658,4.856181));
        points.append(CGPointMake(7785.266992,4.760847));
        points.append(CGPointMake(7825.930608,4.755484));
        points.append(CGPointMake(7895.310450,4.715761));
        points.append(CGPointMake(7924.273355,4.791581));
        points.append(CGPointMake(7963.904465,4.852471));
        points.append(CGPointMake(7988.133746,4.847622));
        points.append(CGPointMake(8011.443576,4.826659));
        points.append(CGPointMake(8080.622759,4.636806));
        points.append(CGPointMake(8102.968193,4.426593));
        points.append(CGPointMake(8126.988265,4.510713));
        points.append(CGPointMake(8168.134679,4.669951));
        points.append(CGPointMake(8192.783575,4.877546));
        points.append(CGPointMake(8218.568141,5.131971));
        points.append(CGPointMake(8249.879053,5.334954));
        points.append(CGPointMake(8271.641812,5.341621));
        points.append(CGPointMake(8293.923030,5.303213));
        points.append(CGPointMake(8329.755630,5.110955));
        points.append(CGPointMake(8354.062829,5.089682));
        points.append(CGPointMake(8377.109253,5.121334));
        points.append(CGPointMake(8415.966958,5.214669));
        points.append(CGPointMake(8441.897111,5.287441));

        
        return points;
    }
}