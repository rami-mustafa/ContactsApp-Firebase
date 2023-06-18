 
import UIKit

class PersonDetailViewController: UIViewController {

   
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personPhoneLabel: UILabel!

    var person:Contacts?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let p = person {
            
            personNameLabel.text = p.kisi_ad
            personPhoneLabel.text = p.kisi_tel
        }

     }
    

   

}
