//
//  ViewController.swift
//  MedicalApp
//
//  Created by Артём Кармазь on 7/29/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit
import Firebase


class StartViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonRounder()
        setupTextFields()
        
        // Add tap to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Up Keyboard when edit
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func enterButtonAction(_ sender: UIButton) {
        
        guard mailTextField.text != "", passwordTextField.text != "" else {
            self.alertNotCorrectData(message: "Please enter your email or password.")
            return
        }
        
        Auth.auth().signIn(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error {
                self.alertNotCorrectData(message: "You entered not correct email or password. Please try again.")
                print(error.localizedDescription)
            }
            if user != nil {
                print("autorization done")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        print("Forgot password")
    }
    
    private final func buttonRounder() {
        enterButton.layer.cornerRadius = 15
        enterButton.layer.borderWidth = 1
        enterButton.layer.borderColor = UIColor.black.cgColor
    }
    
    private final func setupTextFields() {
        mailTextField.delegate = self
        mailTextField.tag = 0
        passwordTextField.delegate = self
        passwordTextField.tag = 1
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - (keyboardSize.height / 2)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension StartViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension StartViewController {
    private func alertNotCorrectData(message: String) {
        let alert = UIAlertController(title: "OOPS!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
