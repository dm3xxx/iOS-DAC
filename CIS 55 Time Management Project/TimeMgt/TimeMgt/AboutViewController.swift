//
//  AboutViewController.swift
//  TimeMgt
//
//  Created by Farthest From The Tree on 6/20/15.
//  Copyright (c) 2015 cisstudents. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var Scroller: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Scroller.scrollEnabled = true
        Scroller.contentSize = CGSizeMake(375, 1600)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
