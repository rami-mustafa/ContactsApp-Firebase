 

import UIKit

class PersonCellTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var personWritingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     }

}
