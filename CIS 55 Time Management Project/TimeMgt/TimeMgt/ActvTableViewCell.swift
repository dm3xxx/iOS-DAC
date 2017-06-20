//
//  ActvTableViewCell.swift
//  TimeMgt
//
//  Created by cisstudents on 6/9/15.
//  Copyright (c) 2015 cisstudents. All rights reserved.
//

import UIKit

class ActvTableViewCell: UITableViewCell {
    
    @IBOutlet var AtvNameLb: UILabel!
    @IBOutlet var STimeLb: UILabel!
    @IBOutlet var ETimeLb: UILabel!
    @IBOutlet var DetailBtnLabel: UIButton!
//    
//    @IBAction func DetailsBtn(sender: AnyObject) {
//        println("press")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        if selected {
//            self.backgroundColor = UIColor.yellowColor()
//        } else {
//            self.backgroundColor = UIColor.clearColor()
//        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ActiveTimeList" {
            println("segue id captured!")
        }
    }

}
