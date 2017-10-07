// окно входа и проверки пароля

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginDataLabel: UILabel!

    static var token: String = ""
    static var ukey = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginPass(_ sender: UIButton) {
        BackendUtilities.sharedInstance.clientRepo.userByLogin(withEmail: email.text, password: password.text, success: { (client) -> Void in
            NSLog("Successfully logged in.");
            
            // Display login confirmation
            let alertController = UIAlertController(title: "Login", message:
                "Successfully logged in", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }) { (error) -> Void in
            NSLog("Error logging in.")
            
            // Display error alert
            let alertController = UIAlertController(title: "Login", message:
                "Login failed", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func enterData(_ sender: UIButton) {
        let user1 = "a"
        let pass1 = "a"
        let user2 = "b"
        let pass2 = "b"
        let user3 = "c"
        let pass3 = "c"
        if (email.text == user1 && password.text == pass1) {
            LoginViewController.token = user1 + "abc"
            LoginViewController.ukey = 1
            loginAccess()
        }
        else if (email.text == user2 && password.text == pass2) {
            LoginViewController.token = user2 + "abc"
            LoginViewController.ukey = 1
            loginAccess()
        }
        else if (email.text == user3 && password.text == pass3) {
            LoginViewController.token = user3 + "abc"
            LoginViewController.ukey = 1
            loginAccess()
        }
        else {
            loginDataLabel.text = "Неверные данные!"
        }
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func loginAccess() {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "tabBarID") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
}

