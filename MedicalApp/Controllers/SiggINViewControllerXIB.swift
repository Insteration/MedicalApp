import UIKit

class SiggINViewControllerXIB: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var userEnter = UserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        
        
        
    }
    
    
    @IBAction func registrationButton(_ sender: UIButton) {
    }
    
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
    }
}

extension SiggINViewControllerXIB: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextfield {
            self.emailTextfield.resignFirstResponder()
            return true
        }
        
        if textField == passwordTextfield {
            self.passwordTextfield.resignFirstResponder()
            return true
        }
        return false
        
        
    }
    
}
