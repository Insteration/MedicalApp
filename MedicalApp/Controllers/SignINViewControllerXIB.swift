import UIKit

class SignINViewControllerXIB: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    func createNotification() { // <---- up view when activate keyboard
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: {nc in self.view.frame.origin.y = -140})
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: {nc in self.view.frame.origin.y = 0})
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
    }
    
    var userEnter = UserProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        createNotification()
    }
    
    
    @IBAction func enterButton(_ sender: UIButton) {
    }
    
    
    @IBAction func registrationButton(_ sender: UIButton) {
    }
    
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
    }
}

extension SignINViewControllerXIB: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}
