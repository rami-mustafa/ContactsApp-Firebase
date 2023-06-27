

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
        
        let indeks = sender as? Int
        
        if segue.identifier == "toDetail" {
            
            let toGoVC = segue.destination as! PersonDetailViewController
            
            toGoVC.person = contactsliste[indeks!]

        }
        
        if segue.identifier == "toUpdate" {
            
            let toGoVC = segue.destination as! EditContactViewController

            toGoVC.person = contactsliste[indeks!]
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
             } else {
                 self.contactsliste = [Contacts]()
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
            }else {
                self.contactsliste = [Contacts]()
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
    
    
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {( contextualAction, view, boolValue )in
//
//                let person = self.contactsliste[indexPath.row]
//                self.ref.child("kisiler").child(person.kisi_id!).removeValue()
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//
//            }
//
//
//           let EditAction = UIContextualAction(style: .normal, title: "Edit") {( contextualAction, view, boolValue )in
//                self.performSegue(withIdentifier: "toUpdate", sender: indexPath.row)
//           }
//
//
//
//           return UISwipeActionsConfiguration(actions: [deleteAction,EditAction])
//       }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let person = self.contactsliste[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            
            let alert = UIAlertController(title: "Deletion process", message: "Delete : \(person.kisi_ad!) ", preferredStyle: .alert)
          
            let cancelAtcion = UIAlertAction(title: "cancel", style: .cancel) { action in
                
            }
            
            let OkAtcion = UIAlertAction(title: "OK", style: .destructive) { action in
                self.ref.child("kisiler").child(person.kisi_id!).removeValue()
                  completion(true)
            }
            
            alert.addAction(cancelAtcion)
            alert.addAction(OkAtcion)
            self.present(alert, animated: true)
            
            
            
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        
        let messageAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            self.performSegue(withIdentifier: "toUpdate", sender: indexPath.row)

            completion(true)
        }
        messageAction.image = UIImage(systemName: "square.and.pencil")
        messageAction.backgroundColor = .systemMint
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction,messageAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let messageAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            self.performSegue(withIdentifier: "toUpdate", sender: indexPath.row)

            completion(true)
        }
        messageAction.image = UIImage(systemName: "square.and.pencil")
        messageAction.backgroundColor = .systemMint
        
        let config = UISwipeActionsConfiguration(actions: [messageAction])
         return config
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
