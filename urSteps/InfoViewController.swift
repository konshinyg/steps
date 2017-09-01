
import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var texter: UITextView!
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromFile()
        texter.text = LoginViewController.token
    }
    
    func readFromFile() {
        if let path = Bundle.main.path(forResource: "workers", ofType: "txt") {
            text = try! String(contentsOfFile: path, encoding: String.Encoding.windowsCP1251)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
