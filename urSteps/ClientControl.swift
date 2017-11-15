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
        userDefClean()
        print("ClientControl: requesting for new access token")
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
                }
            }
            ClientControl.currentClient.requestJSON()
        }.resume()
    } // requestToken ends
    
    func requestJSON(/*infoView: UIViewController*/) {
        print("ClientControl: ok, we have access token, trying to request for JSON data")
        
        guard let accessToken = UserDefaults.standard.object(forKey: "access_token") as? String else {
            print("did't pass guard accessToken")
            return
        }
        
        guard let id = UserDefaults.standard.object(forKey: "userID") as? Int else {
            print("did't pass guard userID")
            return
        }
        print("id: ", id, ", access_token: ", accessToken)

        guard let url = URL(string: stringURL + String(describing: id)) else { return }
        var request = URLRequest(url: url)
        print("request: ", request)
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let response = response as? HTTPURLResponse {
                print("response status: \(response.statusCode)")
                if response.statusCode == 401 {
                    UserDefaults.standard.removeObject(forKey: "access_token")
                    print("ClientControl: failed to get JSON data. Bad access token removed")

                    return
                }
            }
            
            if let error = error {
                let errString = error.localizedDescription
                print(errString)
            } else if data != nil {
                let user = User(data: data!)
                User.currentUser = user
                
                if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary {
                    print("dictionary: ", dictionary)
                }
            }
        }.resume()
    } // requestJSON ends
    
    func searchOldToken() {
        print("searchOldToken")
        let id = UserDefaults.standard.object(forKey: "userID") as! Int
        let accessToken = UserDefaults.standard.object(forKey: "access_token") as! String
        
        let urlString = stringURL + String(describing: id) + "/accessTokens"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "Get"
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        print("request", request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error", error)
            } else if let response = response {
                print("response", response)
            }
            if data != nil {
                if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary {
                    print("dictionary: ", dictionary)
                }
            }
        }.resume()
    }
    
    func userDefClean() {
        print("\(#function)")
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        User.currentUser = nil
    }
}
