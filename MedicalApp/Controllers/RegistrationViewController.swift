//
//  RegistrationTableViewController.swift
//  MedicalApp
//
//  Created by Артем Кармазь on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comfirmPasswordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var fonctionTextField: UITextField!
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var selectPhoto: UIButton!
    
    private let picker = UIImagePickerController()
    private var userStorage: StorageReference!
    private var reference: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonRounder()
        setupTextFields()

        sendRequestButton.isHidden = true
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL: "gs://medicalapp-e7b4b.appspot.com")
        reference = Database.database().reference()
        userStorage = storage.child("users")
        
        // Add tap to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Up Keyboard when edit
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func selectPhotoButton(_ sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func sendRequestButtonAction(_ sender: UIButton) {
        
        guard fullNameTextField.text != "", emailTextField.text != "", passwordTextField.text != "", comfirmPasswordTextField.text != "" else {
            return
        }
        
        if passwordTextField.text == comfirmPasswordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.fullNameTextField.text!
                    changeRequest?.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.user.uid).jpg")
                    let data = self.photoImageView.image?.jpegData(compressionQuality: 0.5)
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metaData, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            
                            if let url = url {
                                let userInfo: [String: Any] = [
                                    "uid": user.user.uid,
                                    "full name": self.fullNameTextField.text!,
                                    "urlToImage": url.absoluteString
                                ]
                                
                                self.reference.child("users").child(user.user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                    })
                    
                    uploadTask.resume()
                
                }
            }
        } else {
            print("Password not match")
        }
        
        
    }
    
    private final func buttonRounder() {
        sendRequestButton.layer.cornerRadius = 15
        sendRequestButton.layer.borderWidth = 1
        sendRequestButton.layer.borderColor = UIColor.black.cgColor
        
        selectPhoto.layer.cornerRadius = 15
        selectPhoto.layer.borderWidth = 1
        selectPhoto.layer.borderColor = UIColor.black.cgColor
    }
    
    
    private final func setupTextFields() {
        emailTextField.delegate = self
        emailTextField.tag = 0
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        comfirmPasswordTextField.delegate = self
        comfirmPasswordTextField.tag = 2
        fullNameTextField.delegate = self
        fullNameTextField.tag = 3
        phoneNumberTextField.delegate = self
        phoneNumberTextField.tag = 4
        fonctionTextField.delegate = self
        fonctionTextField.tag = 5
        organizationTextField.delegate = self
        organizationTextField.tag = 6
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - (keyboardSize.height / 3)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoImageView.image = image
            sendRequestButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
