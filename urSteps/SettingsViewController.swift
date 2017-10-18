// Окно настроек

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var settingsTextView: UITextView!
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var patronymic: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UserDefaults.standard.object(forKey: "firstName") as! String
        let surname = UserDefaults.standard.object(forKey: "lastName") as! String
        nameSurname.text = surname + " " + name
        patronymic.text = UserDefaults.standard.object(forKey: "patronymic") as? String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitUserButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewID") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
}
