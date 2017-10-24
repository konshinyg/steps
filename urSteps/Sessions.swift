//
//  Sessions.swift
//  urSteps
//
//  Created by Core on 24.10.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import Foundation

let apiKey = "YOUR_API_KEY"
let getTokenMethod = "authentication/token/new"
let baseURLSecureString = "https://api.themoviedb.org/3/"
var requestToken: String?
let loginMethod = "authentication/token/validate_with_login"
let userName = "user"
let password = "password"
let getSessionIdMethod = "authentication/session/new"
var sessionID: String?
let getUserIdMethod = "account"
var userID: Int?

func loginButton(sender: UIButton) {
    // create a session here
    getRequestToken()
}

func getRequestToken() {
    let urlString = baseURLSecureString + getTokenMethod + "?api_key=" + apiKey
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, downloadError in
        if let error = downloadError {
            DispatchQueue.main.async() {
                print("Login Failed. (Request token.)")
            }
            print("Could not complete the request \(error)")
        } else {
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            if let token = parsedResult["request_token"] as? String {
                requestToken = token
                loginWithToken(requestToken: requestToken!)
                DispatchQueue.main.async() {
                    print("got request token: \(String(describing: requestToken))")
                }
            } else {
                DispatchQueue.main.async() {
                    print("Login Failed. (Request token.)")
                }
                print("Could not find request_token in \(parsedResult)")
            }
        }
    }
    task.resume()
} // getRequestToken ends

func loginWithToken(requestToken: String) {
    let parameters = "?api_key=\(apiKey)&request_token=\(requestToken)&username=\(userName)&password=\(password)"
    let urlString = baseURLSecureString + loginMethod + parameters
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, downloadError in
        if let error = downloadError {
            DispatchQueue.main.async() {
                print("Login Failed. (Login Step.)")
            }
            print("Could not complete the request \(error)")
        } else {
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let success = parsedResult["success"] as? Bool {
                getSessionID(requestToken: requestToken)
                DispatchQueue.main.async() {
                    print("Login status: \(success)")
                }
            } else {
                if let status_code = parsedResult["status_code"] as? Int {
                    DispatchQueue.main.async() {
                        let message = parsedResult["status_message"]
                        print("\(status_code): \(message!)")
                    }
                } else {
                    DispatchQueue.main.async() {
                        print("Login Failed. (Login Step.)")
                    }
                    print("Could not find success in \(parsedResult)")
                }
            }
        }
    }
    task.resume()
} // loginWithToken ends

func getSessionID(requestToken: String) {
    let parameters = "?api_key=\(apiKey)&request_token=\(requestToken)"
    let urlString = baseURLSecureString + getSessionIdMethod + parameters
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: request) { data, response, downloadError in
        if let error = downloadError {
            DispatchQueue.main.async() {
                print("Login Failed. (Session ID.)")
            }
            print("Could not complete the request \(error)")
        } else {
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let session = parsedResult["session_id"] as? String {
                sessionID = session
                getUserID(sessionID: sessionID!)
                DispatchQueue.main.async() {
                    print("Session ID: \(String(describing: sessionID))")
                }
            } else {
                DispatchQueue.main.async() {
                    print("Login Failed. (Session ID.)")
                }
                print("Could not find session_id in \(parsedResult)")
            }
        }
    }
    task.resume()
} // getSessionID ends

func getUserID(sessionID: String) {
    let urlString = baseURLSecureString + getUserIdMethod + "?api_key=" + apiKey + "&session_id=" + sessionID
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: request) { data, response, downloadError in
        if let error = downloadError {
            DispatchQueue.main.async() {
                print("Login Failed. (Get userID.)")
            }
            print("Could not complete the request \(error)")
        } else {
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let user = parsedResult["id"] as? Int {
                userID = user
                completeLogin()
                DispatchQueue.main.async() {
                    print("your user id: \(String(describing: userID))")
                }
            } else {
                DispatchQueue.main.async() {
                    print("Login Failed. (Get userID.)")
                }
                print("Could not find user id in \(parsedResult)")
            }
        }
    }
    task.resume()
}// getUserID ends

func completeLogin() {
    let getFavoritesMethod = "account/\(String(describing: userID))/favorite/movies"
    let urlString = baseURLSecureString + getFavoritesMethod + "?api_key=" + apiKey + "&session_id=" + sessionID!
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: request) { data, response, downloadError in
        if let error = downloadError {
            DispatchQueue.main.async() {
                print("Cannot retrieve information about user \(String(describing: userID)).")
            }
            print("Could not complete the request \(error)")
        } else {
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let results = parsedResult["results"] as? NSArray {
                DispatchQueue.main.async() {
                    let firstFavorite = results.firstObject as? NSDictionary
                    let title = firstFavorite?.value(forKey: "title")
                    print("Title: \(title!)")
                }
            } else {
                DispatchQueue.main.async() {
                    print("Cannot retrieve information about user \(String(describing: userID)).")
                }
                print("Could not find 'results' in \(parsedResult)")
            }
        }
    }
    task.resume()
} // completeLogin ends
