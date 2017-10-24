//
//  Client.swift
//  urSteps
//
//  Created by Core on 24.10.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import Foundation

let stringURL = "https://yoursteps.ru/api/users/"

class ClientControl {
    
    static var currentClient = ClientControl()
    
    func requestToken(url: URL, email: String, password: String) {
        print("first requesting to access token")
        let bodyData = "email=\(email)&password=\(password)"
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if let error = error {
                let errString = error.localizedDescription
                print(errString)
                
            } else if data != nil {
                if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    let accessToken = dictionary?["id"] as! String
                    let id = dictionary?["userId"] as! Int
                    
                    // -- Запись результатов в dictionary
                    //  var results = [String: AnyObject]()
                    //  results = ["at": accessToken as AnyObject, "id": id as AnyObject]
                    //  print("results: \(results)")
                    
                    UserDefaults.standard.set(accessToken, forKey: "access_token")
                    UserDefaults.standard.set(id, forKey: "userID")
                    UserDefaults.standard.synchronize()
                    self.requestJSON(stringUrl: stringURL, token: accessToken, userID: id)
                }
            }
        }.resume()
    } // requestToken ends
    
    func requestJSON(stringUrl: String, token: String, userID: Int) {
        print("ok, we have access token, requesting for data")
        guard let url = URL(string: stringUrl + String(describing: userID)) else { return }
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let response = response as? HTTPURLResponse {
                print("response status: \(response.statusCode)")
                print("response allHeaderFields: \(response.allHeaderFields as NSDictionary)")
            }
            
            if let error = error {
                let errString = error.localizedDescription
                print(errString)
            } else if data != nil {
                //                let user = User(data: data!)
                //                User.currentUser = user
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    print(dictionary!)
                    
                } catch { print("error") }
            }
            }.resume()
    } // requestJSON ends
    
    func userDefClean() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
            //            print(key, UserDefaults.standard.object(forKey: key)!)
        }
    }
}
