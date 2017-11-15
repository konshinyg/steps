// Главное окна профиля

import UIKit

class InfoViewController: UIViewController {
        
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var patronymic: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var birthdayDate: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var region: UITextField!
    @IBOutlet weak var jobSearchStatus: UITextField!
    @IBOutlet weak var wishSalaryMin: UITextField!
    @IBOutlet weak var wishSalaryMax: UITextField!
    @IBOutlet weak var emailAdress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InfoViewController viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parseData()
    }
    
    func parseData() {
        if let user = User.currentUser?.dictionary {
            firstNameLabel.text = user["firstName"] as? String
            lastNameLabel.text = user["lastName"] as? String
            patronymic.text = user["patronymic"] as? String
            phone.text = user["phone"] as? String
            sex.text = user["sex"] as? String
            birthdayDate.text = user["birthday"] as? String
        }
    }
    
//    @IBAction func menuButtonTapped(_ sender: Any) {
//        let leftWidth = MMDrawerController.setMaximumLeftDrawerWidth(centerContainer!)
//        leftWidth(320, true, nil)
//        
//        centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
//    }
}
