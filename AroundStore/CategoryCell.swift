

import UIKit

class CategoryCell: UITableViewCell {
    

    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var categoryCheckImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
