//
//  AnalyzerViewController.swift
//  TimeMgt
//
//  Created by Farthest From The Tree on 6/20/15.
//  Copyright (c) 2015 cisstudents. All rights reserved.
//

import UIKit
import JBChart

class AnalyzerViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {

    @IBOutlet weak var barChart: JBBarChartView!
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBOutlet var fromDate: UIDatePicker!
    @IBOutlet var toDate: UIDatePicker!
    
    @IBAction func calculate(sender: AnyObject) {
        
        let from = fromDate.date
        let to = toDate.date
        
        var fromStr = nsdf.stringFromDate(from)
        var toStr = nsdf.stringFromDate(to)
        
        if toStr < fromStr {
            let temp = fromStr
            fromStr = toStr
            toStr = temp
        }
        
        println(fromStr)
        println(toStr)
        
        let fIndex = FindByStr(allDays, fromStr)
        let tIndex = FindByStr(allDays, toStr)
        
        var maxPerDay = 24*((tIndex! - fIndex!)+1) // ADDED
        println("days = \(tIndex! - fIndex!)")
        println("day * mins \(maxPerDay)")

        chartData.removeAll()
        chartData = Array(count: chartLegend.count, repeatedValue: 0)
        println("chart size \(chartData.count)")
        
        for date in fIndex!...tIndex! {
            for ent in allDays[date].events {
                let eIdx = find(chartLegend, ent.name)
                let less = min(ent.sTime.count, ent.eTime.count)
                for iii in 0..<less {
                    chartData[eIdx!] += NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: ent.sTime[iii], toDate: ent.eTime[iii], options: nil).hour
                }
            }
        }
        for i in chartData {
            println("chartData[] = \(i)")
            maxPerDay -= i
        }
        println("maxPerDay \(maxPerDay)")
        
        chartData[sizeOfLegend] = maxPerDay // ADDED
        println("index \(sizeOfLegend)")
        
        barChart.reloadData()
        showChart()
    }
    
    let nsdf = NSDateFormatter()
    var allDays : [DRecord] = []
    var chartLegend: [String] = []
    var chartData: [Int] = []
    var sizeOfLegend: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        barChart.backgroundColor = UIColor.lightGrayColor()
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = 50
        
//        barChart.reloadData()
//        barChart.setState(.Collapsed, animated: false)
        
        sizeOfLegend = chartLegend.count
        println("size = \(sizeOfLegend)")
        chartLegend.append("Wasted")
        println("legend count = \(chartLegend.count)")
        nsdf.dateFormat = "dd/MM/yyyy"
        
        let dayCounts = allDays.count
        let from = nsdf.dateFromString(allDays[0].dateStr)
        let to = nsdf.dateFromString(allDays[dayCounts - 1].dateStr)
        
        fromDate.minimumDate = from
        fromDate.maximumDate = to
        toDate.minimumDate = from
        toDate.maximumDate = to
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var header = UILabel(frame: CGRectMake(0, 0, barChart.frame.width, 50))
        header.textColor = UIColor.blackColor()
        header.font = UIFont.systemFontOfSize(24)
        header.text = "Activities Duration"
        header.textAlignment = NSTextAlignment.Center
        
        barChart.headerView = header
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.reloadData()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideChart()
    }
    
    func hideChart() {
        barChart.setState(.Collapsed, animated: true)
    }
    
    func showChart() {
        barChart.setState(.Expanded, animated: true)
    }
    
    // MARK: JBBarChartView
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        //return CGFloat(chartData[Int(index)])
        var value = CGFloat(chartData[Int(index)])
        println("bcv index \(index) value \(value)")
        return value
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        if Int(index) < sizeOfLegend {
            return colorIdx[Int(index)]
        } else {
            return UIColor.whiteColor()
        }
    }
    
    // for the label at bottom to display more information at that bar
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let data = chartData[Int(index)]
        let key  = chartLegend[Int(index)]
        
        informationLabel.text = "Time spent on \(key): \(data) hours"
        informationLabel.textAlignment = NSTextAlignment.Center
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        informationLabel.text = ""
    }
}
