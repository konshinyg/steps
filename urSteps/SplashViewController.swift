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
        if UserDefaults.standard.object(forKey: "access_token") != nil {
            gotoTabBar()
        } else {
            gotoLogin()
        }
    }
    
    func gotoLogin() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginViewID") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
        self.dismiss(animated: true, completion: nil)
    }
    
    func gotoTabBar() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarID") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
        self.dismiss(animated: true, completion: nil)
    }
}
