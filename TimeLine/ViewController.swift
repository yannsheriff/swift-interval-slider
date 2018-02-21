//
//  ViewController.swift
//  TimeLine
//
//  Created by CHERIF Yannis on 13/02/2018.
//  Copyright © 2018 CHERIF Yannis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimeLineControlDelegate {
    
    @IBOutlet weak var TimeLineControl: TimeLineControl!
    
    func userIsDragging(_ values: Array<CGFloat>) {
        
    }
    
    func userDidEndDrag(_ values: Array<CGFloat>) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimeLineControl.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

