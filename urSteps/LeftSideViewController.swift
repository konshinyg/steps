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
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = mainStoryBoard.instantiateViewController(withIdentifier: "infoViewID") as! InfoViewController
            let leftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
            let leftSideNav = UINavigationController(rootViewController: leftSideViewController)
            let centerNav = UINavigationController(rootViewController: centerViewController)
            
            centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
            centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            self.present(centerContainer!, animated: true, completion: nil)
            break
            
        case "HR-вопросы":
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = mainStoryBoard.instantiateViewController(withIdentifier: "recViewID") as! RecViewController
            let leftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
            let leftSideNav = UINavigationController(rootViewController: leftSideViewController)
            let centerNav = UINavigationController(rootViewController: centerViewController)
            
            centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
            centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            self.present(centerContainer!, animated: true, completion: nil)
            break
            
        case "Настройки":
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = mainStoryBoard.instantiateViewController(withIdentifier: "settingsViewID") as! SettingsViewController
            let leftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
            let leftSideNav = UINavigationController(rootViewController: leftSideViewController)
            let centerNav = UINavigationController(rootViewController: centerViewController)
            
            centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
            centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            self.present(centerContainer!, animated: true, completion: nil)
            break
            
        default: break
        }
    }
}
