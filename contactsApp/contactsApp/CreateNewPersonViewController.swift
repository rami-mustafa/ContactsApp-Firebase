 

import UIKit
import Firebase

class CreateNewPersonViewController: UIViewController {

    
    
    @IBOutlet weak var personNameTextField: UITextField!
    
    @IBOutlet weak var personPhoneTextField: UITextField!
    
    var ref:DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()


     }
    
    
    
    
 
    @IBAction func add(_ sender: Any) {
        
        if let name = personNameTextField.text , let phone = personPhoneTextField.text {
            
            addContact(kisi_ad: name, kisi_tel: phone)
        }
        
    }
    
    func addContact(kisi_ad:String , kisi_tel:String ) {
        
        let dict:[String:Any] = ["kisi_id":"","kisi_ad":kisi_ad,"kisi_tel":kisi_tel]
        
        let newRef = ref?.child("kisiler").childByAutoId()
        
        newRef?.setValue(dict)
        
    }
    
}
