// Главное окна профиля

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var companyLabel: UITextView!
    @IBOutlet weak var adressLabel: UITextField!

    var dataArray = [userData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let urlString = "http://facepalmapp.com/cornelius.json"
//        switch LoginViewController.token {
//        case "aabc":
//            giveData(urlString: urlString, token: 1)
//            break
//        case "babc":
//            giveData(urlString: urlString, token: 2)
//            break
//        case "cabc":
//            giveData(urlString: urlString, token: 3)
//            break
//        default: break
//        }
    }
    
    func giveData(urlString: String, token: Int) {
        let url = URL(string: urlString)
        do {
            let urlConverted = try String(contentsOf: url!, encoding: .utf8)
            let parseToDict = parse(json: urlConverted)
            self.dataArray = testDataParser(dictionary: parseToDict!)
            nameLabel.text = dataArray[token].name
            surnameLabel.text = dataArray[token].username
            phoneLabel.text = dataArray[token].phone
            companyLabel.text = dataArray[token].companyBS + ",\n" +
                                dataArray[token].companyName + ",\n" +
                                dataArray[token].companyCatchPhrase
            adressLabel.text = dataArray[token].addressCity
            
        } catch {}
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
