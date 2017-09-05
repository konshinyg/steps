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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        switch menuItems[indexPath.row] {
        case "Профиль":
            let vc: InfoViewController =
                storyboard.instantiateViewController(withIdentifier: "infoViewID") as! InfoViewController
            self.present(vc, animated: true, completion: nil)
            break
        case "HR-вопросы":
            let vc: RecViewController =
                storyboard.instantiateViewController(withIdentifier: "recViewID") as! RecViewController
            self.present(vc, animated: true, completion: nil)
            break
        case "Настройки":
            let vc: SettingsViewController =
                storyboard.instantiateViewController(withIdentifier: "settingsViewID") as! SettingsViewController
            self.present(vc, animated: true, completion: nil)
            break
        default: break
        }
    }
}
