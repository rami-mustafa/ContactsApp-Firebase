

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    
    var liste = [String]()
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            liste = ["ece","mehmet","talat"]

        
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        SearchBar.delegate = self
        
        
        ref = Database.database().reference()
    
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            
        }
        
        if segue.identifier == "toUpdate" {
            
        }
    }

}

extension ViewController: UITableViewDelegate , UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liste.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCellTableViewCell
        
        cell.personWritingLabel.text = liste[indexPath.row]
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    
}
extension ViewController:   UISearchBarDelegate {
    
    
    
    
    
}
