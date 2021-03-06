//
//  BackendUtilities.swift
//  Loopback-Swift-Example
//
//  Created by Kevin Goedecke on 12/10/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import Foundation
import LoopBack

class BackendUtilities  {
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate!)
    let DEFAULTS_CURRENT_USER_ID_KEY: String = "LBUserRepositoryCurrentUserId"
    var adapter: LBRESTAdapter
    var clientRepo: ClientRepository
    
    static let sharedInstance = BackendUtilities()
    
    init() {
        adapter = appDelegate?.adapter as LBRESTAdapter!
        clientRepo = adapter.repository(with: ClientRepository.self) as! ClientRepository
    }
}
