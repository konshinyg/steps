// окно входа и проверки пароля

import UIKit
import LoopBack

var accessData: NSDictionary?

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginDataLabel: UILabel!
    
    static var token: String = ""
    let stringURL = "https://yoursteps.ru/api/users/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -- loginPass (LoopBack)
    @IBAction func loginPass(_ sender: UIButton) {
        let user = "varapaevov@mail.ru"
        let pass = "myUrStepspass1"

        BackendUtilities.sharedInstance.clientRepo.userByLogin(withEmail: user, password: pass, success: { (client) -> Void in
            NSLog("Successfully logged in.")
            LoginViewController.token = BackendUtilities.sharedInstance.adapter.accessToken
            
            // Display login confirmation
//            let alertController = UIAlertController(title: "Login", message:
//                "Successfully logged in", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
        }) { (error) -> Void in
            NSLog("Error logging in. \(String(describing: error))")
            self.loginDataLabel.text = "Неверные данные!"

            // Display error alert
//            let alertController = UIAlertController(title: "Login", message:
//                "Login failed", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
        }
    } // loginPass ends
    
    // MARK: -- simple loginPass
    @IBAction func simpleLoginPass(_ sender: UIButton) {
        requestToken(url: URL(string: stringURL + "login")!, email: "varapaevov@mail.ru", password: "myUrStepspass1")
        
        requestJSON(stringUrl: stringURL)
        
        loginAccess()
    }
    
    func requestToken(url: URL, email: String, password: String) {
        let bodyData = "email=\(email)&password=\(password)"
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if let error = error {
                let errString = error.localizedDescription
                print(errString)
                
            } else if data != nil {
                
                if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    let accesstoken = dictionary?["id"] as! String
                    let id = dictionary?["userId"] as! Int
                    let ttl = dictionary?["ttl"] as! Int
                    
                    var results = [String: AnyObject]()
                    results = ["at": accesstoken as AnyObject, "id": id as AnyObject]
                    print("results: \(results)")
                    
                    // MARK: - Store UID & AccessToken
                    UserDefaults.standard.set(true, forKey: "userLoggedIn")
                    UserDefaults.standard.set(id, forKey: "userId")
                    UserDefaults.standard.set(ttl, forKey: "ttl")
                    UserDefaults.standard.set(accesstoken, forKey: "accessToken")
                    UserDefaults.standard.synchronize()
                }
            }
        }
        task.resume()
    }
    
    func requestJSON(stringUrl: String) {
        
        let userId = UserDefaults.standard.object(forKey: "userId") as! Int
        let token = UserDefaults.standard.object(forKey: "accessToken") as! String
        let ttl = UserDefaults.standard.object(forKey: "ttl") as! Int
        print("ttl: \(ttl) mlsec")
        
        let urlWithParams = stringUrl + String(userId) + "?access_token=" + token
        var newRequest = URLRequest(url: URL(string: urlWithParams)!)
        newRequest.httpMethod = "Get"
        let newTask = URLSession.shared.dataTask(with: newRequest as URLRequest) {
            data, response, error in

            if let error = error {
                let errString = error.localizedDescription
                print(errString)
                
            } else if data != nil {
                
                if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    for (key, value) in dictionary! {
                        UserDefaults.standard.set(value, forKey: key as! String)
                    }
                }
            }
        }
        newTask.resume()
    }
    
    func loginAccess() {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "tabBarID") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
}

