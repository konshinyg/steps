//
//  ViewController.swift
//  urSteps
//
//  Created by Core on 11.08.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginDataLabel: UILabel!
    
    @IBAction func enterData(_ sender: UIButton) {
        let user = "c"
        let pass = "c"
        
        if username.text == user && password.text == pass {
            loginDataLabel.text = "Correct data!"
            loginAccess()
        }
        else {
            loginDataLabel.text = "Incorrect data!"
        }
        username.resignFirstResponder()
        password.resignFirstResponder()

    }
    func loginAccess() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarID")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

