 

import UIKit
import Firebase

class EditContactViewController: UIViewController {

    @IBOutlet weak var personNameTextField: UITextField!
   
    @IBOutlet weak var personPhoneTextField: UITextField!
    
    var person:Contacts?
    var ref:DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        
        if let p = person {
            
            personNameTextField.text = p.kisi_ad
            personPhoneTextField.text = p.kisi_tel
        }

     }
    

    @IBAction func save(_ sender: Any) {
        
        if let p = person  , let name = personNameTextField.text , let phone = personPhoneTextField.text {
          
            personUpdate(kisi_id:p.kisi_id! ,kisi_ad:name , kisi_tel:phone)
         }
        
    }
    func personUpdate(kisi_id:String ,kisi_ad:String , kisi_tel:String ) {
        
 
        ref.child("kisiler").child(kisi_id).updateChildValues(["kisi_id":"","kisi_ad":kisi_ad,"kisi_tel":kisi_tel])
        
     
        
    }
    

}
