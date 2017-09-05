//
//  changeController.swift
//  urSteps
//
//  Created by Core on 05.09.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit

class changeController: NSObject {

    public func change(indentifier: String, controller: UIViewController) {
    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let centerViewController = mainStoryBoard.instantiateViewController(withIdentifier: "infoViewID") as! InfoViewController
    
    let leftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
    
    let leftSideNav = UINavigationController(rootViewController: leftSideViewController)
    let centerNav = UINavigationController(rootViewController: centerViewController)
    
    centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
    
    centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
    centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
    }
    
}
