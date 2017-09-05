// Окно настроек

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitUserButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewID") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func settingToMenuButton(_ sender: Any) {
        let leftWidth = MMDrawerController.setMaximumLeftDrawerWidth(centerContainer!)
        leftWidth(320, true, nil)
        
        centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
}
