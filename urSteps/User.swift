//
//  User.swift
//  urSteps
//
//  Created by Core on 14.10.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import Foundation

class User {
    
    var dictionary: NSDictionary?
    var data: Data?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    init(data: Data) {
        self.data = data
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            print("get user data from UserDefaults")
            let userData = UserDefaults.standard.object(forKey: "currentUser") as? Data
            if let userData = userData {
                if let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary {
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            print("set user data to UserDefaults")
            _currentUser = user
            
            if let user = user {
                UserDefaults.standard.set(user.data, forKey: "currentUser")
            } else {
                UserDefaults.standard.set(nil, forKey: "currentUser")
            }
            UserDefaults.standard.synchronize()
        }
    }
}
