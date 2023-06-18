

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    
    var contactsliste = [Contacts]()
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        SearchBar.delegate = self
        
        
        ref = Database.database().reference()
    
        takeAllContacts()
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            
        }
        
        if segue.identifier == "toUpdate" {
            
        }
    }
    
    func takeAllContacts () {
         ref.child("kisiler").observe(.value, with: { snapshot in
             if let gelenVeriButtunu = snapshot.value as? [String:AnyObject] {
                 self.contactsliste.removeAll()
                 for gelenSatirVerisi in gelenVeriButtunu {
                    if let sozluk = gelenSatirVerisi.value as? NSDictionary {
                        let key = gelenSatirVerisi.key
                        let kisi_ad = sozluk["kisi_ad"] as? String ?? ""
                        let kisi_tel = sozluk["kisi_tel"] as? String ?? ""
                        
                        let person = Contacts(kisi_id: key, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                        
                        self.contactsliste.append(person)
                    }
                }
            }
             DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
        })
    }
    
    
    func Search(searchWord:String ) {
        ref.child("kisiler").observe(.value, with: { snapshot in

            if let gelenVeriButtunu = snapshot.value as? [String:AnyObject] {
                self.contactsliste.removeAll()
                for gelenSatirVerisi in gelenVeriButtunu {
                    if let sozluk = gelenSatirVerisi.value as? NSDictionary {
                        let key = gelenSatirVerisi.key
                        let kisi_ad = sozluk["kisi_ad"] as? String ?? ""
                        let kisi_tel = sozluk["kisi_tel"] as? String ?? ""
                        
                        
                        if kisi_ad.contains(searchWord){
                            
                            let person = Contacts(kisi_id: key, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                            
                            self.contactsliste.append(person)
                            
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
        })
    }

}

extension ViewController: UITableViewDelegate , UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsliste.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let person = contactsliste[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCellTableViewCell
        
        cell.personWritingLabel.text = "\(person.kisi_ad!) - \(person.kisi_tel!)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {( contextualAction, view, boolValue )in
            let person = self.contactsliste[indexPath.row]
            
            self.ref.child("kisiler").child(person.kisi_id!).removeValue()
            }
           
           let EditAction = UIContextualAction(style: .normal, title: "Edit") {( contextualAction, view, boolValue )in
                self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row)
           }
           
           
           
           return UISwipeActionsConfiguration(actions: [deleteAction,EditAction])
       }
    
}
extension ViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchText == "" {
            takeAllContacts()
        }else {
            Search(searchWord:searchText )

        }
        
    }
    
    
}
