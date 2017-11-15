//
//  SplashViewController.swift
//  urSteps
//
//  Created by Core on 24.10.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SplashViewController viewDidLoad")

        ClientControl.currentClient.requestJSON()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("SplashViewController: TOKEN = ", UserDefaults.standard.object(forKey: "access_token") as Any)
            if UserDefaults.standard.object(forKey: "access_token") != nil {
                print("-- gotoBarTab")
                self.gotoTabBar()
            } else {
                print("-- gotoLogin")
                self.gotoLogin()
            }
        }
    }
    
    func gotoLogin() {
        self.performSegue(withIdentifier: "splashLoginSegue", sender: self)
    }
    
    func gotoTabBar() {
        self.performSegue(withIdentifier: "splashTabBarSegue", sender: self)
    }
}
