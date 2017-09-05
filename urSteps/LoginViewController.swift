// окно входа и проверки пароля

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
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

    @IBAction func enterData(_ sender: UIButton) {
        let user1 = "a"
        let pass1 = "a"
        let user2 = "b"
        let pass2 = "b"
        let user3 = "c"
        let pass3 = "c"
        if (username.text == user1 && password.text == pass1) {
            LoginViewController.token = user1 + "abc"
            LoginViewController.ukey = 1
            loginAccess()
        }
        else if (username.text == user2 && password.text == pass2) {
            LoginViewController.token = user2 + "abc"
            LoginViewController.ukey = 1
            loginAccess()
        }
        else if (username.text == user3 && password.text == pass3) {
            LoginViewController.token = user3 + "abc"
            LoginViewController.ukey = 1
            loginAccess()
        }
        else {
            loginDataLabel.text = "Неверные данные!"
        }
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func loginAccess() {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerViewController = mainStoryBoard.instantiateViewController(withIdentifier: "infoViewID") as! InfoViewController
        
        let leftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
        
        let leftSideNav = UINavigationController(rootViewController: leftSideViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
        centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
        self.present(centerContainer!, animated: false, completion: nil)
    }
}

