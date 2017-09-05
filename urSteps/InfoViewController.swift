// Главное окна профиля

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var companyLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = getURL(token: LoginViewController.token)
        giveData(urlString: url)
    }
    
    func getURL(token: String) -> String {
        var urlString = "http://jsonplaceholder.typicode.com/users"
        switch token {
        case "aabc":
            urlString.append("/1")
            break
        case "babc":
            urlString.append("/2")
            break
        case "cabc":
            urlString.append("/3")
            break
        default: break
        }
        return urlString
    }
    
    func giveData(urlString: String) {
        let url = URL(string: urlString)
        do {
            let urlConverted = try String(contentsOf: url!, encoding: .utf8)
            let parseToDict = parse(json: urlConverted)
//            print(parseToDict!)
            let data = testDataParse(dictionary: parseToDict!)
            nameLabel.text = data.name
            surnameLabel.text = data.username
            phoneLabel.text = data.phone
            companyLabel.text = data.companyArray.joined(separator: ",\n")
        } catch {}
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func testDataParse(dictionary: [String: Any]) -> testData {
        let data = testData()
        if let id = dictionary["id"] as? Int {
            data.id = id
        }
        data.username = dictionary["username"] as! String
        data.name = dictionary["name"] as! String
        data.email = dictionary["email"] as! String
        data.phone = dictionary["phone"] as! String
        data.addresArray = convertDictToArray(dictionary: dictionary["address"] as! [String : Any])
        data.companyArray = convertDictToArray(dictionary: dictionary["company"] as! [String : Any])
        return data
    }
    
    func convertDictToArray(dictionary: [String: Any]) -> [String] {
        var array = [String]()
        for (_, v) in dictionary {
            if v is String {
                array.append(v as! String)
            } else { }
        }
        return array
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        let leftWidth = MMDrawerController.setMaximumLeftDrawerWidth(centerContainer!)
        leftWidth(320, true, nil)
        
        centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        centerContainer!.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
}
