//
//  RecViewController.swift
//  urSteps
//
//  Created by Core on 11.08.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit

class RecViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var timerBar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
