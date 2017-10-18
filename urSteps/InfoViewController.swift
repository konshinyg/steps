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
    
    var dataArray = [userData]()
    
    var currentUser: Client
    
    required init(coder aDecoder: NSCoder) {
        currentUser = Client()
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackendUtilities.sharedInstance.clientRepo.findCurrentUser(success: { (client) -> Void in
            NSLog("Found user, see InfoViewController")
            self.currentUser = client as! Client
        }) { (error) -> Void in
            NSLog("Error fetching user, see InfoViewController")
        }
        giveData()
    }
    
    func giveData() {
        firstNameLabel.text = UserDefaults.standard.object(forKey: "firstName") as? String
        lastNameLabel.text = UserDefaults.standard.object(forKey: "lastName") as? String
        patronymic.text = UserDefaults.standard.object(forKey: "patronymic") as? String
        phone.text = UserDefaults.standard.object(forKey: "phone") as? String
        sex.text = UserDefaults.standard.object(forKey: "sex") as? String
        birthdayDate.text = UserDefaults.standard.object(forKey: "birthday") as? String

    }
    
    func parse(json: String) -> [String: Any]? {
        guard let data = json.data(using: .utf8, allowLossyConversion: false)
            else { return nil }
        do {
            return try JSONSerialization.jsonObject(
                with: data, options: []) as? [String: Any]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    func testDataParser(dictionary: [String: Any]) -> [userData] {
        
        let jsonData = dictionary["results"] as! [AnyObject]
        for json in jsonData {
            let secData = userData()
            secData.id = json["id"] as! Int
            secData.username = json["username"] as! String
            secData.name = json["name"] as! String
            secData.email = json["email"] as! String
            secData.phone = json["phone"] as! String
            
            let address = json["address"] as! [String : AnyObject]
            secData.addressCity = address["city"] as! String
            secData.addressStreet = address["street"] as! String
            secData.addressSuite = address["suite"] as! String
            secData.addressZipCode = address["zipcode"] as! String
            
            let company = json["company"] as! [String : AnyObject]
            secData.companyBS = company["bs"] as! String
            secData.companyName = company["name"] as! String
            secData.companyCatchPhrase = company["catchPhrase"] as! String
            
            dataArray.append(secData)
        }
        return dataArray
    }
}
