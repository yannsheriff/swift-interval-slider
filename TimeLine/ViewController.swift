//
//  ViewController.swift
//  TimeLine
//
//  Created by CHERIF Yannis on 13/02/2018.
//  Copyright © 2018 CHERIF Yannis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimeLineControlDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var TimeLineControl: TimeLineControl!
    @IBOutlet weak var stepper: UIStepper!
    
    func userIsDragging(_ values: Array<CGFloat>) {
        label.text = String(describing: values[0])
    }
    
    func userDidEndDrag(_ values: Array<CGFloat>) {
        
    }
    
    @IBAction func didStep(_ sender: UIStepper) {
        if (sender.value > 1) {
            TimeLineControl.addStep()
        } else {
            TimeLineControl.removeStep()
        }
        stepper.value = 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.value = 1
        TimeLineControl.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

