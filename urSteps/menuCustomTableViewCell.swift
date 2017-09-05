// контроллер ячейки в таблице бокового меню

import UIKit

class menuCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var menuCellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
