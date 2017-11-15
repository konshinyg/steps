// Боковое меню

import UIKit

class LeftSideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var patronymic: UILabel!
    
    var menuItems: [String] = ["Профиль", "HR-вопросы", "Настройки"]

    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseData() {
        if let user = User.currentUser?.dictionary {
            name.text = user["firstName"] as? String
            surname.text = user["lastName"] as? String
            patronymic.text = user["patronymic"] as? String
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuCustomTableViewCell
        cell.menuCellLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch menuItems[indexPath.row] {

        case "Профиль":
            switchTo(controllerIdentifier: "infoViewID", storyBoardName: "Main")
            break
            
        case "HR-вопросы":
            switchTo(controllerIdentifier: "recViewID", storyBoardName: "Main")
            break
            
        case "Настройки":
            switchTo(controllerIdentifier: "settingsViewID", storyBoardName: "Main")
            break
            
        default: break
        }
    }
    
    func switchTo(controllerIdentifier: String, storyBoardName: String) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: controllerIdentifier)
        self.present(vc, animated: true, completion: nil)
    }
    
}
