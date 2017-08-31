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
        let user1 = "a"
        let pass1 = "a"
        let user2 = "b"
        let pass2 = "b"
        let user3 = "c"
        let pass3 = "c"
        
        if username.text == user1 && password.text == pass1 {
            loginDataLabel.text = "Correct data!"
            loginAccess(tokenstr: user1)
        }
        if username.text == user2 && password.text == pass2 {
            loginDataLabel.text = "Correct data!"
            loginAccess(tokenstr: user2)
        }
        if username.text == user3 && password.text == pass3 {
            loginDataLabel.text = "Correct data!"
            loginAccess(tokenstr: user3)
        }
        else {
            loginDataLabel.text = "Incorrect data!"
        }
        username.resignFirstResponder()
        password.resignFirstResponder()

    }
    func loginAccess(tokenstr: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarID")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegueID" {
            let dest = segue.destination
            if username.text == "user1" {
            dest.setValue("user1", forKeyPath: "user")
            }
            if username.text == "user2" {
                dest.setValue("user2", forKeyPath: "user")
            }
            if username.text == "user3" {
                dest.setValue("user3", forKeyPath: "user")
            }
        }
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

