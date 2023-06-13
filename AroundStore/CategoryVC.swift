
import UIKit

protocol CategoryVCDelegate: AnyObject {
  func typeDone(_ controller: CategoryVC, didSelectTypes types: String)
}

class CategoryVC: UITableViewController {
    
    
    private let categoryType = ["맛집", "한식", "중식", "일식", "양식"]
    weak var delegate: CategoryVCDelegate?
    var selectedCategory: String = "맛집"
    private let categoryImage = ["shop", "bibimbap", "dimsum", "ramen", "meat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryType.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        cell.categoryLbl.text = categoryType[indexPath.row]
        cell.categoryImage.image = UIImage(named: categoryImage[indexPath.row])
        
        
        
        if cell.categoryLbl.text == selectedCategory {
            
            cell.categoryCheckImage.image = UIImage(systemName: "checkmark.circle.fill")
            
        } else {
            cell.categoryCheckImage.image = UIImage()
        }
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        selectedCategory = categoryType[indexPath.row]
        tableView.reloadData()
        

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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

extension CategoryVC {
    
    
    @IBAction func doneBtnWasPressed(_ sender: AnyObject) {
        
       
        
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        category = selectedCategory
        
        UserDefaults.standard.set(selectedCategory, forKey: "category")

        self.navigationController!.popViewController(animated: true)
    }
    
    
}
