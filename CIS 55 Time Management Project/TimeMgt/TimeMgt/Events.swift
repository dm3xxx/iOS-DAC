//
//  Events.swift
//  TimeMgt
//
//  Created by cisstudents on 6/10/15.
//  Copyright (c) 2015 cisstudents. All rights reserved.
//

import UIKit

let colorIdx : [UIColor] = [
    UIColor.redColor(), UIColor.greenColor(),
    UIColor(red: 0.4, green: 0.4, blue: 1, alpha: 1), UIColor.cyanColor(),
    UIColor.yellowColor(), UIColor.magentaColor(),
    UIColor.orangeColor(), UIColor.purpleColor(),
    UIColor.brownColor()]
let maxAtv = colorIdx.count

// Event record that collect all the start and end time of
// the event in the same day
class Events: NSObject {
    
    var name = ""
    var sTime: [NSDate] = []
    var eTime: [NSDate] = []
    
}

func == (lhs: Events, rhs: String) -> Bool {
    return (lhs.name == rhs)
}

func != (lhs: Events, rhs: String) -> Bool {
    return (lhs.name != rhs)
}

func < (lhs: Events, rhs: String) -> Bool {
    return (lhs.name < rhs)
}

func <= (lhs: Events, rhs: String) -> Bool {
    return (lhs.name <= rhs)
}

func > (lhs: Events, rhs: String) -> Bool {
    return (lhs.name > rhs)
}

func >= (lhs: Events, rhs: String) -> Bool {
    return (lhs.name >= rhs)
}

func == (lhs: String, rhs: Events) -> Bool {
    return (lhs == rhs.name)
}

func != (lhs: String, rhs: Events) -> Bool {
    return (lhs != rhs.name)
}

func < (lhs: String, rhs: Events) -> Bool {
    return (lhs < rhs.name)
}

func <= (lhs: String, rhs: Events) -> Bool {
    return (lhs <= rhs.name)
}

func > (lhs: String, rhs: Events) -> Bool {
    return (lhs > rhs.name)
}

func >= (lhs: String, rhs: Events) -> Bool {
    return (lhs >= rhs.name)
}

func FindByStr(ary: [Events], str: String) -> Int? {
    for (ii, e) in enumerate(ary) {
        if e == str {
            return ii
        }
    }
    return nil
}