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
    
    @IBOutlet weak var agreeButton: UIButton!
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
    var agree: Bool = false
    var timer : Timer!
    private var userStorage: StorageReference!
    private var reference: DatabaseReference!
    var imageController = UIImagePickerController()
    
    
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerMoves), userInfo: nil, repeats: true)
    }
    @objc func timerMoves(){
        let number = phoneNumberTextField.text!
        number.checkNumber(field: phoneNumberTextField)
        let email:String = emailTextField.text!
        email.checkEmail(field: emailTextField)
        checkFields()
    }
    
    func checkFields(){
        let email : String = emailTextField.text!
        let emailBool = email.isValidEmail(emailStr: email)
        let phone : String = phoneNumberTextField.text!
        let phoneBool = phone.validate(value: phone)
        
        if fullNameTextField.text! != "" && fonctionTextField.text! != "" &&  passwordTextField.text! != "" &&  organizationTextField.text! != "" &&   agree != false && emailBool && phoneBool && photoImageView.image != UIImage(named: "question")  {
            sendRequestButton.alpha = 1.0
            sendRequestButton.isEnabled = true
        } else {
            sendRequestButton.alpha = 0.2
            sendRequestButton.isEnabled = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTimer()
        buttonRounder()
        setupTextFields()
        imageController.delegate = self
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
        let alert = UIAlertController(title: "User Photo", message: "choose photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: openCamera(action:)))
        alert.addAction(UIAlertAction(title: "Open Library", style: .default, handler: openLibrary(action:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: openLibrary(action:)))
        present(alert, animated: true, completion:nil)
    }
    
    
    @IBAction func sendRequestButtonAction(_ sender: UIButton) {
        
        guard fullNameTextField.text != "", emailTextField.text != "", passwordTextField.text != "", comfirmPasswordTextField.text != "" else {
//            self.alertNotCorrectData(message: "You entered not correct fields. Please try again.")
            //"notCorrectFields"
            self.alertNotCorrectData(message: NSLocalizedString("notCorrectFields", comment: ""))
            return
        }
        
        if passwordTextField.text == comfirmPasswordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if let error = error {
                    self.alertNotCorrectData(message: "Something wrong. Get error!")
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
                            self.alertNotCorrectData(message: "\(error!.localizedDescription)")
                            print(error!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                self.alertNotCorrectData(message: "\(error!.localizedDescription)")
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
            alertNotCorrectData(message: "Password not match.")
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
    
    
    @IBAction func agreeAction(_ sender: UIButton) {
        agree = !agree
        if agree {
            agreeButton.setTitle("✓", for: .normal)
            agreeButton.setTitleColor(.black, for: .normal)
        } else {
            agreeButton.setTitle(" ", for: .normal)
            agreeButton.setTitleColor(.black, for: .normal)
        }
    }
    
    
    
    private final func setupTextFields() {
        photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 3.5
        photoImageView.image  = UIImage(named: "question")
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .white
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
    
    func openLibrary(action:UIAlertAction!){
        imageController.sourceType = .photoLibrary
        imageController.allowsEditing = true
        present(imageController, animated: true, completion: nil)
    }
    
    func openCamera(action:UIAlertAction!){
        if imageController.sourceType == .camera {
            imageController.sourceType = .camera
            imageController.mediaTypes = [kCIAttributeTypeImage as String]
            imageController.cameraCaptureMode = .photo
            imageController.allowsEditing = true
            present(imageController, animated: true, completion: nil)
        }
        else {
            print("error")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoImageView.image = image
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

extension RegistrationViewController {
    private func alertNotCorrectData(message: String) {
        let alert = UIAlertController(title: "OOPS!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


