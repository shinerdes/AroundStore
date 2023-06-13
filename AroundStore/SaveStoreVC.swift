
import UIKit
import SafariServices

class SaveStoreVC: UITableViewController {
  
    @IBOutlet var allRemoveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let allRemoveImg = UIImage(systemName: "trash.square.fill", withConfiguration: imageConfig)
        
        allRemoveBtn.setTitle("", for: .normal)
        allRemoveBtn.setImage(allRemoveImg, for: .normal)

        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveStoreCell", for: indexPath) as! SaveStoreCell
        
        cell.storeNameLbl.text = storeArray[indexPath.row].placeName
        cell.categoryNameLbl.text = storeArray[indexPath.row].categoryName
        cell.addressLbl.text = storeArray[indexPath.row].addressName
        cell.mapUrl = storeArray[indexPath.row].placeURL
        
 
        cell.viewController = self
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        
        if editingStyle == .delete {
            
            storeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let encoded = try? JSONEncoder().encode(storeArray) {
                UserDefaults.standard.set(encoded, forKey: "storeArray")
            }
            
          
            
            let alert = UIAlertController(title: "삭제 완료", message: nil, preferredStyle: .alert)
            
            let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
            imgViewTitle.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            alert.view.addSubview(imgViewTitle)
            
            self.present(alert, animated: true, completion: nil)
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                alert.dismiss(animated: true, completion: nil)}
            )
            
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            
        }
        
    }
    
    
    @IBAction func allRemoveBtnWasPressed(_ sender: Any) {
     
        
        let sheet = UIAlertController(title: "경고", message: "전체 삭제를 하시겠습니까?", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "No!", style: .default, handler: { _ in print("아니요 클릭") }))
        sheet.addAction(UIAlertAction(title: "Yes!", style: .destructive, handler: { _ in
            storeArray.removeAll()
            if let encoded = try? JSONEncoder().encode(storeArray) {
                UserDefaults.standard.set(encoded, forKey: "storeArray")
            }
            self.tableView.reloadData()
        }))
     
        present(sheet, animated: true)

    }
    
  
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

 
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
