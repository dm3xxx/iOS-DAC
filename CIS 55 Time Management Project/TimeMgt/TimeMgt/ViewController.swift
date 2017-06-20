//
//  ViewController.swift
//  TimeMgt
//
//  Created by cisstudents on 6/9/15.
//  Copyright (c) 2015 cisstudents. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XYPieChartDelegate, XYPieChartDataSource {

    @IBOutlet var ActTableView: UITableView!
    @IBOutlet var PieChartV: XYPieChart!
    var fadeInAddView: UIView!
    var fiTextField: UITextField!
    var fiAddBtn: UIButton!
    
    let atvCellStr = "atvCell"
    let nsdf = NSDateFormatter()
    
    var atvTypes = ["Sleep", "Eat", "Commute", "Work", "Relax"]
    //var atvTypes = [String]()
    var showAddView = false
    var rcdIdx = -1
    var lastRcdDateStr: String!
    
    var allDays : [DRecord] = []
    var slices: NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        slices = NSMutableArray()
        PieChartV.delegate = self
        PieChartV.dataSource = self
        
        nsdf.dateFormat = "dd/MM/yyyy"
        navigationItem.title = nsdf.stringFromDate(NSDate())
        allDays = MakeSampleDate()
        //PieChartV.backgroundColor = UIColor.clearColor()
        InitFadeIn()
        InitPieChart()
        
        PieChartV.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(ActTableView)
        self.view.addSubview(PieChartV)
        self.view.addSubview(fadeInAddView)
        
        ActTableView.backgroundColor = UIColor.lightGrayColor()

        UpdatePieChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return atvTypes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(atvCellStr, forIndexPath: indexPath) as ActvTableViewCell

        var hasStartTime = false
        var hasEndTime = false
        
        nsdf.timeStyle = .ShortStyle
        cell.backgroundColor = colorIdx[indexPath.row]
        cell.AtvNameLb.text = atvTypes[indexPath.row]
        cell.STimeLb.text = "Last start: "
        cell.ETimeLb.text = "Last end: "
        
        if let dayIdx = FindByStr(allDays, navigationItem.title!) {
            let events : [Events] = allDays[dayIdx].events
            if let eIdx = FindByStr(events, cell.AtvNameLb.text!) {
                let sTimeCnt = events[eIdx].sTime.count
                let eTimeCnt = events[eIdx].eTime.count
                if  sTimeCnt > 0 {
                    let time = events[eIdx].sTime[sTimeCnt - 1]
                    let tStr = nsdf.stringFromDate(time)
                    
                    cell.STimeLb.text = cell.STimeLb.text! + tStr
                    hasStartTime = true
                }
                if eTimeCnt == sTimeCnt {
                    let time = events[eIdx].eTime[eTimeCnt - 1]
                    let tStr = nsdf.stringFromDate(time)
                    
                    cell.ETimeLb.text = cell.ETimeLb.text! + tStr
                    hasEndTime = true
                } else if eTimeCnt < sTimeCnt {
                    cell.ETimeLb.text = cell.ETimeLb.text! + "on going"
                    hasEndTime = true
                }
            }
        }
        
        if !hasStartTime {
            cell.STimeLb.text = cell.STimeLb.text! + "[none]"
        }
        if !hasEndTime {
            cell.ETimeLb.text = cell.ETimeLb.text! + "[none]"
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            atvTypes.removeAtIndex(indexPath.row)
            tableView.reloadData()
            UpdatePieChart()
            //println(atvTypes[indexPath.row] + " should be deleted")
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            println("add")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        nsdf.dateFormat = "dd/MM/yyyy"
        
        if rcdIdx < 0 {     // no event on going
            
            // 1) if no current date exist add a new day
            var ii = FindByStr(allDays, nsdf.stringFromDate(NSDate()))
            if ii == nil {
                allDays.append(DRecord())
                ii = allDays.count - 1
                allDays[ii!].dateStr = nsdf.stringFromDate(NSDate())
                allDays[ii!].events = [Events]()
            }
            
            // 2) if no current event exist add a new event
            var ee = FindByStr(allDays[ii!].events, atvTypes[indexPath.row])
            if ee == nil {
                allDays[ii!].events.append(Events())
                ee = allDays[ii!].events.count - 1
                allDays[ii!].events[ee!].name = atvTypes[indexPath.row]
            }
            rcdIdx = ee!
            
            // 3) add new start time
            allDays[ii!].events[rcdIdx].sTime.append(NSDate())
            lastRcdDateStr = nsdf.stringFromDate(NSDate())
            
        } else {

            // 1 stop @ the same day
            if lastRcdDateStr == nsdf.stringFromDate(NSDate()) {
                
                if let dd = FindByStr(allDays, lastRcdDateStr) {
                    if let ee = FindByStr(allDays[dd].events, atvTypes[indexPath.row]) {
                        
                        if ee == rcdIdx {   // stop the same event
                            allDays[dd].events[ee].eTime.append(NSDate())
                            rcdIdx = -1
                            lastRcdDateStr = ""
                        } else {    // user started another event actually
                            allDays[dd].events[rcdIdx].eTime.append(NSDate())
                            allDays[dd].events[ee].sTime.append(NSDate())
                            rcdIdx = ee
                        }
                        
                    } else {    // user actually started a non-existing event
                        
                        // 1 stop pervious event
                        allDays[dd].events[rcdIdx].eTime.append(NSDate())
                        
                        // 2 create the new event and add a start time
                        allDays[dd].events.append(Events())
                        rcdIdx = allDays[dd].events.count - 1
                        allDays[dd].events[rcdIdx].name = atvTypes[indexPath.row]
                        allDays[dd].events[rcdIdx].sTime.append(NSDate())
                    }
                } else {
                    lastRcdDateStr = ""
                    rcdIdx = -1
                }
                
            } else {    // 2 stopped number of day(s) after
                
                // 1) find the pervious date
                if let oD = FindByStr(allDays, lastRcdDateStr) {
                    
                    let pvDay = nsdf.dateFromString(lastRcdDateStr)!
                    let eDay = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: 1, toDate: pvDay, options: nil)
                    
                    // 2) stop the pervous event
                    allDays[oD].events[rcdIdx].eTime.append(eDay!)
                }
                
                // 3 add a new date, new event, new start time
                allDays.append(DRecord())
                let ii = allDays.count - 1
                allDays[ii].dateStr = nsdf.stringFromDate(NSDate())
                allDays[ii].events = [Events]()
                allDays[ii].events.append(Events())
                allDays[ii].events[0].name = atvTypes[indexPath.row]
                allDays[ii].events[0].sTime.append(NSDate())
                
                lastRcdDateStr = nsdf.stringFromDate(NSDate())
                rcdIdx = 0
            }
            UpdatePieChart()
        }
        
        tableView.reloadData()
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ActiveTimeList" {
            
            let dailyAtvCtrlr = segue.destinationViewController as AtvDailyTableViewController
            let btn = sender as UIButton
            let cell = btn.superview?.superview as UITableViewCell
            let idx: NSIndexPath = ActTableView.indexPathForCell(cell)!
            nsdf.dateFormat = "dd/MM/yyyy"
            
            if let dd = FindByStr(allDays, nsdf.stringFromDate(NSDate())) {
                let es: [Events] = allDays[dd].events
                if let ee = FindByStr(es, self.atvTypes[idx.row]) {
                    dailyAtvCtrlr.event = es[ee]
                }
            }
        } else if segue.identifier == "analyzerID" {
            let analyzerCtlr = segue.destinationViewController as AnalyzerViewController
            
            analyzerCtlr.chartLegend.removeAll()
            analyzerCtlr.chartLegend = atvTypes
            analyzerCtlr.allDays.removeAll()
            analyzerCtlr.allDays = allDays
            analyzerCtlr.chartData.removeAll()
            analyzerCtlr.chartData = Array(count: analyzerCtlr.chartLegend.count, repeatedValue: 0)
        }
    }
    
    func UpdatePieChart() {

        var maxPerDay = 1440
        nsdf.dateFormat = "dd/MM/yyyy"
        slices.removeAllObjects()
        
        if let dd = FindByStr(allDays, nsdf.stringFromDate(NSDate())) {
            for s in atvTypes {
                var eMins = 0
                if let ee = FindByStr(allDays[dd].events, s) {
                    let e = allDays[dd].events[ee]
                    let less = min(e.sTime.count, e.eTime.count)
                    for ii in 0..<less {
                        eMins += NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: e.sTime[ii], toDate: e.eTime[ii], options: nil).minute
                    }
                }
                maxPerDay -= eMins
                slices.addObject(eMins)
            }
        }
        slices.addObject(maxPerDay)
        PieChartV.reloadData()
    }
    
    // xyPieChart Begin Code
    func InitPieChart() {
        let pi = CGFloat(M_PI)
        let midW = PieChartV.frame.size.width / 2
        let midH = PieChartV.frame.size.height / 2
        let rad = min(midW, midH) - 15
        
        PieChartV.startPieAngle = 1.5 * pi
        PieChartV.pieCenter = CGPointMake(midW, midH)
        PieChartV.pieRadius = rad
        PieChartV.labelColor = UIColor.blackColor()
    }
    
    // Implement Data Source Methods:
    
    //  - (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart;
    func numberOfSlicesInPieChart(pieChart: XYPieChart!) -> UInt
    {
        return UInt(slices.count)
    }
    
    //  - (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
    func pieChart(pieChart: XYPieChart!, valueForSliceAtIndex index: UInt) -> CGFloat
    {
        return CGFloat(slices[Int(index)] as NSNumber)
    }
    
    //  - (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index;	//optional
    func pieChart(pieChart: XYPieChart!, colorForSliceAtIndex index: UInt) -> UIColor!
    {
        if Int(index) < atvTypes.count {
            return colorIdx[Int(index)]
        } else {
            return UIColor.whiteColor()
        }
    }
    
    //  - (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index;	//optional
    //func pieChart(pieChart: XYPieChart!, textForSliceAtIndex index: UInt) -> String { }
    
    
    // Implement  Delegate Methods (OPTIONAL):
    
    //  - (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index;
    func pieChart(pieChart: XYPieChart!, willSelectSliceAtIndex index: UInt)
    {
    }
    
    //  - (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index;
    func pieChart(pieChart: XYPieChart!, didSelectSliceAtIndex index: UInt)
    {
    }
    
    //  - (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index;
    func pieChart(pieChart: XYPieChart!, willDeselectSliceAtIndex index: UInt)
    {
    }
    
    //  - (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index;
    func pieChart(pieChart: XYPieChart!, didDeselectSliceAtIndex index: UInt)
    {
    }
    // xyPieChart End Code
    
    // fade in views functions
    func InitFadeIn() {
        fadeInAddView = UIView()
        fadeInAddView.frame = CGRect(x: 0, y: 379, width: 375, height: 288)
        fadeInAddView.backgroundColor = UIColor.lightGrayColor()
        fadeInAddView.alpha = 0
        fiTextField = UITextField(frame: CGRect(x: 51, y: 51, width: 275, height: 30))
        fiTextField.placeholder = "Enter a new activity name here"
        fiTextField.text = ""
        fiTextField.borderStyle = .RoundedRect
        fadeInAddView.addSubview(fiTextField)
        fiAddBtn = UIButton(frame: CGRect(x: 170, y: 100, width: 35, height: 30))
        fiAddBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        fiAddBtn.setTitle("Add", forState: .Normal)
        fiAddBtn.addTarget(self, action: "addAtvBtn:", forControlEvents: .TouchUpInside)
        fadeInAddView.addSubview(fiAddBtn)
    }
    
    func addAtvBtn(sender: UIButton!) {
        
        if atvTypes.count == colorIdx.count {
            let alertBox = UIAlertView(title: "Error!", message: "Number of color reach max available colors cannot add", delegate: nil, cancelButtonTitle: "OK")
            alertBox.show()
            FadeView()
        } else {
            let empty = fiTextField.text.isEmpty
            let found = find(atvTypes, fiTextField.text)
        
            if found == nil && !empty {
                atvTypes.append(fiTextField.text)
                fiTextField.text = ""
                ActTableView.reloadData()
                FadeView()
            } else if found != nil && !empty {
                let alertBx = UIAlertView(title: "Error!", message: fiTextField.text + " already exist!", delegate: nil, cancelButtonTitle: "OK")
                alertBx.show()
            }
        }
    }
    
    @IBAction func addBtn(sender: AnyObject) {
        FadeView()
    }
    
    func FadeView() {
        if showAddView {
            fadeInAddView.alpha = 0
            ActTableView.alpha = 1
        } else {
            ActTableView.alpha = 0
            fadeInAddView.alpha = 1
        }
        showAddView = !showAddView
    }
}

