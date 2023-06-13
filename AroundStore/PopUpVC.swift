
import Foundation
import SafariServices

class PopUpVC: UIViewController {
    weak var viewController: UIViewController?
    
    var placeName = ""
    var placeURL = ""
    
    var categoryName = ""
    var addressName = ""
    var roadAddressName = ""
    
    var id = ""
    var phone = ""
    
    var categoryGroupCode = ""
    var categoryGroupName = ""
    
    var x = ""
    var y = ""
    
    //    Document(placeName: "시간을 들이다 본점", distance: "", placeURL: "http://place.map.kakao.com/789369795", categoryName: "음식점 > 간식 > 제과,베이커리", addressName: "서울 동작구 신대방동 342-23", roadAddressName: "서울 동작구 보라매로 80", id: "789369795", phone: "02-812-2158", categoryGroupCode: "FD6", categoryGroupName: "음식점", x: "126.92802859597275", y: "37.496509891518436")
    
    @IBOutlet var popView: UIView!
    
    @IBOutlet var placeNameLbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    
    
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var urlBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popView.layer.cornerRadius = 15
        popView.layer.borderWidth = 2
        popView.layer.borderColor = UIColor.gray.cgColor
        
        placeNameLbl.text = placeName
        categoryLbl.text = categoryName
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let saveBtnImg = UIImage(systemName: "square.and.arrow.down.fill", withConfiguration: imageConfig)
        let urlBtnImg = UIImage(systemName: "link.circle.fill", withConfiguration: imageConfig)
        
        urlBtn.setTitle("", for: .normal)
        urlBtn.setImage(saveBtnImg, for: .normal)
        
        saveBtn.setTitle("", for: .normal)
        saveBtn.setImage(saveBtnImg, for: .normal)
        saveBtn.imageView?.contentMode = .scaleAspectFill
        
        saveBtn.contentVerticalAlignment = .fill
        saveBtn.contentHorizontalAlignment = .fill
        saveBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        saveBtn.layer.cornerRadius = 5
        
        urlBtn.setTitle("", for: .normal)
        urlBtn.setImage(urlBtnImg, for: .normal)
        urlBtn.contentVerticalAlignment = .fill
        urlBtn.contentHorizontalAlignment = .fill
        urlBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        urlBtn.layer.cornerRadius = 5
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            self.popView.transform = .identity
            
        }, completion: nil)
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func urlBtnWasPressed(_ sender: Any) {
        
        guard let url = URL(string: placeURL) else { return }
        let SafariView = SFSafariViewController(url: url)
        
        present(SafariView, animated: true)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != self.popView
        { self.dismiss(animated: false, completion: nil) }
    }
    
    
    @IBAction func saveBtnWasPressed(_ sender: Any) {
        
        var redundancy = false
        
        for i in 0..<storeArray.count {
            if (id == storeArray[i].id) {
                redundancy = true
            } else {
                
            }
        }
        if (redundancy == true) {
            
            let sheet = UIAlertController(title: "경고", message: "중복으로 인한 등록불가", preferredStyle: .alert)
            sheet.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in print("클릭") }))
            present(sheet, animated: true)
            
            
        } else {
            
            storeArray.append(Store(placeName: placeName, placeURL: placeURL, categoryName: categoryName, addressName: addressName, roadAddressName: roadAddressName, id: id, phone: phone, categoryGroupCode: categoryGroupCode, categoryGroupName: categoryGroupName, x: x, y: y))
            
            
            if let encoded = try? JSONEncoder().encode(storeArray) {
                UserDefaults.standard.set(encoded, forKey: "storeArray")
            }
            
            
            let alert = UIAlertController(title: "저장 완료", message: nil, preferredStyle: .alert)
            
            let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
            imgViewTitle.image = UIImage(systemName: "checkmark.circle.fill")
            alert.view.addSubview(imgViewTitle)
            
            
            self.present(alert, animated: true, completion: nil)
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                alert.dismiss(animated: true, completion: nil)}
            )
            
        }
        
    }
    
}

