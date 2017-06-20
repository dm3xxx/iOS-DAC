//
//  DRecord.swift
//  TimeMgt
//
//  Created by cisstudents on 6/10/15.
//  Copyright (c) 2015 cisstudents. All rights reserved.
//

import UIKit

// Daily Record which contant a list of events on that day
class DRecord: NSObject {
    
    var dateStr: String!
    var events: [Events]!
}

func == (lhs: DRecord, rhs: String) -> Bool {
    return (lhs.dateStr == rhs)
}

func != (lhs: DRecord, rhs: String) -> Bool {
    return (lhs.dateStr != rhs)
}

func < (lhs: DRecord, rhs: String) -> Bool {
    return (lhs.dateStr < rhs)
}

func <= (lhs: DRecord, rhs: String) -> Bool {
    return (lhs.dateStr <= rhs)
}

func > (lhs: DRecord, rhs: String) -> Bool {
    return (lhs.dateStr > rhs)
}

func >= (lhs: DRecord, rhs: String) -> Bool {
    return (lhs.dateStr >= rhs)
}

func == (lhs: String, rhs: DRecord) -> Bool {
    return (lhs == rhs.dateStr)
}

func != (lhs: String, rhs: DRecord) -> Bool {
    return (lhs != rhs.dateStr)
}

func < (lhs: String, rhs: DRecord) -> Bool {
    return (lhs < rhs.dateStr)
}

func <= (lhs: String, rhs: DRecord) -> Bool {
    return (lhs <= rhs.dateStr)
}

func > (lhs: String, rhs: DRecord) -> Bool {
    return (lhs > rhs.dateStr)
}

func >= (lhs: String, rhs: DRecord) -> Bool {
    return (lhs >= rhs.dateStr)
}

func FindByStr(ary: [DRecord], str: String) -> Int? {
    for (ii, r) in enumerate(ary) {
        if r == str {
            return ii
        }
    }
    return nil
}

func MakeSampleDate() -> [DRecord] {
    var fmtr = NSDateFormatter()
    var records : [DRecord] = []
    
    fmtr.dateFormat = "dd/MM/yyyy"
    //fmtr.timeStyle = .ShortStyle
    
    for date in 19...21 {
        var today = DRecord()
        var events: [Events] = []
        var sleep = Events()
        var eat = Events()
        var com = Events()
        var work = Events()
        var relx = Events()
        
        sleep.name = "Sleep"
        let sleepS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 0, minute: 0, second: 0, nanosecond: 0)
        let sleepE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 8, minute: 15, second: 0, nanosecond: 0)
        sleep.sTime.append(sleepS!)
        sleep.eTime.append(sleepE!)
        
        eat.name = "Eat"
        let bfEatS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 8, minute: 15, second: 0, nanosecond: 0)
        let bfEatE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 8, minute: 35, second: 0, nanosecond: 0)
        eat.sTime.append(bfEatS!)
        eat.eTime.append(bfEatE!)
        
        com.name = "Commute"
        let comS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 8, minute: 35, second: 0, nanosecond: 0)
        let comE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 9, minute: 0, second: 0, nanosecond: 0)
        com.sTime.append(comS!)
        com.eTime.append(comE!)
        
        work.name = "Work"
        let workS1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 9, minute: 0, second: 0, nanosecond: 0)
        let workE1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 13, minute: 0, second: 0, nanosecond: 0)
        work.sTime.append(workS1!)
        work.eTime.append(workE1!)
        
        let lunchS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 13, minute: 0, second: 0, nanosecond: 0)
        let lunchE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 14, minute: 0, second: 0, nanosecond: 0)
        eat.sTime.append(lunchS!)
        eat.eTime.append(lunchE!)
        
        let workS2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 14, minute: 0, second: 0, nanosecond: 0)
        let workE2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 18, minute: 0, second: 0, nanosecond: 0)
        work.sTime.append(workS2!)
        work.eTime.append(workE2!)
        
        let comS1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 18, minute: 0, second: 0, nanosecond: 0)
        let comE1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 19, minute: 0, second: 0, nanosecond: 0)
        com.sTime.append(comS1!)
        com.eTime.append(comE1!)
        
        let dinS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 19, minute: 0, second: 0, nanosecond: 0)
        let dinE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 20, minute: 0, second: 0, nanosecond: 0)
        eat.sTime.append(dinS!)
        eat.eTime.append(dinE!)
        
        relx.name = "Relax"
        let relx1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date, hour: 20, minute: 0, second: 0, nanosecond: 0)
        let relx2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: date + 1, hour: 0, minute: 0, second: 0, nanosecond: 0)
        relx.sTime.append(relx1!)
        relx.eTime.append(relx2!)
        
        events.append(sleep)
        events.append(eat)
        events.append(com)
        events.append(work)
        events.append(relx)
        
        today.dateStr = fmtr.stringFromDate(sleepS!)
        today.events = events
        records.append(today)
    }
    
    for halfDay in 22...22 {
        var today = DRecord()
        var events: [Events] = []
        var sleep = Events()
        var eat = Events()
        var com = Events()
        var work = Events()
        var relx = Events()
        
        sleep.name = "Sleep"
        let sleepS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 0, minute: 0, second: 0, nanosecond: 0)
        let sleepE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 8, minute: 15, second: 0, nanosecond: 0)
        sleep.sTime.append(sleepS!)
        sleep.eTime.append(sleepE!)
        
        eat.name = "Eat"
        let bfEatS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 8, minute: 15, second: 0, nanosecond: 0)
        let bfEatE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 8, minute: 35, second: 0, nanosecond: 0)
        eat.sTime.append(bfEatS!)
        eat.eTime.append(bfEatE!)
        
        com.name = "Commute"
        let comS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 8, minute: 35, second: 0, nanosecond: 0)
        let comE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 9, minute: 0, second: 0, nanosecond: 0)
        com.sTime.append(comS!)
        com.eTime.append(comE!)
        
        work.name = "Work"
        let workS1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 9, minute: 0, second: 0, nanosecond: 0)
        let workE1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 13, minute: 0, second: 0, nanosecond: 0)
        work.sTime.append(workS1!)
        work.eTime.append(workE1!)
        
        let lunchS = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 13, minute: 0, second: 0, nanosecond: 0)
        let lunchE = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 14, minute: 0, second: 0, nanosecond: 0)
        eat.sTime.append(lunchS!)
        eat.eTime.append(lunchE!)
        
        let workS2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 14, minute: 0, second: 0, nanosecond: 0)
        let workE2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 6, day: halfDay, hour: 18, minute: 0, second: 0, nanosecond: 0)
        work.sTime.append(workS2!)
        work.eTime.append(workE2!)
        
        events.append(sleep)
        events.append(eat)
        events.append(com)
        events.append(work)
        //events.append(relx)
        
        today.dateStr = fmtr.stringFromDate(sleepS!)
        today.events = events
        records.append(today)
    }
    
    return records
}