// Окно настроек

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var settingsTextView: UITextView!
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var patronymic: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parseData()
    }
    
    func parseData() {
        if let user = User.currentUser?.dictionary {
            let name = user["firstName"] as! String
            let surname = user["lastName"] as! String
            nameSurname.text = surname + " " + name
            patronymic.text = user["patronymic"] as? String
            if let sexValue = user.value(forKey: "sex") as? Int {
                if sexValue == 1 { sex.text = "Мужчина, " }
                else { sex.text = "Женщина, " }
            }
            if let birthdayValue = user.value(forKey: "birthday") as? String {
                birthday.text = "родился: " + birthdayValue
            }
            phone.text = user["phone"] as? String
            emailLabel.text = user["email"] as? String
            if let avatarURL = user["avatarUrl"] as? String {
                let url = URL(string: "https://yoursteps.ru" + avatarURL)
                avatarImage.setImageWith(url, placeholderImage: UIImage(named: "Avatar.png"))
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitUserButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "access_token")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SplashViewController = storyboard.instantiateViewController(withIdentifier: "SplashView") as! SplashViewController
        present(vc, animated: true, completion: nil)
    }
}
