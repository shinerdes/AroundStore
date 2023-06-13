

import UIKit
import SafariServices

class SaveStoreCell: UITableViewCell {

    weak var viewController: UIViewController?
 
    @IBOutlet var storeNameLbl: UILabel!
    @IBOutlet var categoryNameLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var urlBtn: UIButton!
    


    var mapUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let urlBtnImg = UIImage(systemName: "link.circle.fill", withConfiguration: imageConfig)
        
        urlBtn.setTitle("", for: .normal)
        urlBtn.setImage(urlBtnImg, for: .normal)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func urlBtnWasPressed(_ sender: Any) {
       
        guard let url = URL(string: mapUrl) else { return }
        let SafariView = SFSafariViewController(url: url)
        
        SafariView.transitioningDelegate = self
        
        viewController?.present(SafariView, animated: true)
        
    }
    
}


extension SaveStoreCell: UIViewControllerTransitioningDelegate {}
