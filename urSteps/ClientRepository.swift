//
//  ClientRepository.swift
//  Loopback-Swift-Example
//
//  Created by Kevin Goedecke on 12/9/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import Foundation
import LoopBack

class ClientRepository: LBUserRepository {
    override init!(className name: String!) {
        super.init(className: "users")
    }
    override init() {
        super.init(className: "users")
    }
}

class Client: LBUser {
    
}
