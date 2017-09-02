
import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var texter: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func readFromFile() -> String {
        var result = ""
        
        if let path = Bundle.main.path(forResource: "work3", ofType: "json") {
            result = try! String(contentsOfFile: path, encoding: String.Encoding.windowsCP1251)
        }
        return result
    }
        @IBAction func parseButton(_ sender: UIButton) {
//        let text: String = readFromFile()
        let url = URL(string: "http://jsonplaceholder.typicode.com/users/1")
        do {
            let urlConverted = try String(contentsOf: url!, encoding: .utf8)
            let parseResult = parse(json: urlConverted)
            print(parseResult!)
        } catch {}
//        let sParse = secondParse(dictionary: parseResult!)
//        print(sParse)
            
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
    
    func secondParse(dictionary: [String : Any]) -> UserData {
        
        let data = UserData()
        if let id = dictionary["id"] as? Int {
            data.id = id
        }
        data.name = dictionary["name"] as! String /*
        data.surname = dictionary["surname"] as! String
        data.fatherName = dictionary["fathername"] as! String
        data.gender = dictionary["gender"] as! String
        data.jobSearchStatus = dictionary["jobSearchStatus"] as! String
        data.birthdayDate = dictionary["birthdayDate"] as! String
        data.region = dictionary["region"] as! String
        data.phone = dictionary["phone"] as! String */
        return data
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
