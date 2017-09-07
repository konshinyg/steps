// Боковое меню

import UIKit

class LeftSideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menuItems: [String] = ["Профиль", "HR-вопросы", "Настройки"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
