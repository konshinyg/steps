// окно входа и проверки пароля

import UIKit
import LoopBack

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = "varapaevov@mail.ru"
        password.text = "myUrStepspass1"
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
            let tokenLoopBack = BackendUtilities.sharedInstance.adapter.accessToken
            
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
    } // loginPass (LoopBack) ends
    
    // MARK: -- simple loginPass
    @IBAction func simpleLoginPass(_ sender: UIButton) {
        ClientControl.currentClient.requestToken(url: URL(string: stringURL + "login")!, email: email.text!, password: password.text!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            self.loginAccess()
        }
    }
    
    func loginAccess() {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "tabBarID") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
}

