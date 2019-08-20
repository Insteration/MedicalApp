//
//  SignUPFinalViewController.swift
//  MedicalApp
//
//  Created by Денис Андреев on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUPFinalViewController: UIViewController {
    
    var agree: Bool = false
    var timer:Timer!
    var imageController = UIImagePickerController()
    
    
    private var userStorage: StorageReference!
    private var reference: DatabaseReference!
    
    @IBOutlet weak var userPhotoImage: UIImageView!
    
    @IBOutlet weak var organizationTextField: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var agreeMyButton: UIButton!
    @IBOutlet weak var fonctionTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var changePhoto: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    func changeObjects(){
        userPhotoImage.layer.cornerRadius = self.userPhotoImage.frame.size.width / 3.5
        userPhotoImage.image  = UIImage(named: "question")
        userPhotoImage.clipsToBounds = true
        userPhotoImage.backgroundColor = .white
        changePhoto.backgroundColor = .white
        changePhoto.setTitle("Set Photo", for: .normal)
        changePhoto.layer.cornerRadius = 20
        sendBtn.layer.cornerRadius = 30
        fullNameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        fonctionTextField.attributedPlaceholder = NSAttributedString(string: "Fonction", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        organizationTextField.attributedPlaceholder = NSAttributedString(string: "Organisation", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Pays", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerMoves), userInfo: nil, repeats: true)
    }
    @objc func timerMoves(){
        let number = phoneTextField.text!
        number.checkNumber(field: phoneTextField)
        let email:String = emailTextField.text!
        email.checkEmail(field: emailTextField)
        checkFields()
    }
    
    func checkFields(){
        let email : String = emailTextField.text!
        let emailBool = email.isValidEmail(emailStr: email)
        let phone : String = phoneTextField.text!
        let phoneBool = phone.validate(value: phone)
        
        if fullNameTextField.text! != "" &&  passwordTextField.text! != "" &&  fonctionTextField.text! != "" &&  confirmPasswordTextField.text! != "" &&  organizationTextField.text! != "" &&   agree != false && emailBool && phoneBool && userPhotoImage.image != UIImage(named: "question")  {
            sendBtn.alpha = 1.0
            sendBtn.isEnabled = true
        } else {
            sendBtn.alpha = 0.2
            sendBtn.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        imageController.delegate = self
        createTimer()
        changeObjects()
        let storage = Storage.storage().reference(forURL: "gs://medicalapp-e7b4b.appspot.com")
        reference = Database.database().reference()
        userStorage = storage.child("users")
    }
    
    @IBAction func agreeButtonAction(_ sender: Any) {
        agree = !agree
        if agree {
            agreeMyButton.setTitle("✓", for: .normal)
            agreeMyButton.setTitleColor(.black, for: .normal)
        } else {
            agreeMyButton.setTitle(" ", for: .normal)
            agreeMyButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBAction func photoButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "User Photo", message: "choose photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: openCamera(action:)))
        alert.addAction(UIAlertAction(title: "Open Library", style: .default, handler: openLibrary(action:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: openLibrary(action:)))
        present(alert, animated: true, completion:nil)
    }
    
    
    @IBAction func sendRequest(_ sender: UIButton) {
        
        
//        guard nameTextField.text != "", emailTextField.text != "", .text != "", comfirmPasswordTextField.text != "" else {
//            self.alertNotCorrectData(message: "You entered not correct fields. Please try again.")
//            "notCorrectFields"
//            self.alertNotCorrectData(message: NSLocalizedString("notCorrectFields", comment: ""))
//            return
//        }
//
//        if passwordTextField.text == confirmPasswordTextField.text {
//            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
//
//                if let error = error {
//                    self.alertNotCorrectData(message: "Something wrong. Get error!")
//                    print(error.localizedDescription)
//                }
//
//                if let user = user {
//
//                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                    changeRequest?.displayName = self.fullNameTextField.text!
//                    changeRequest?.commitChanges(completion: nil)
//
//                    let imageRef = self.userPhotoImage.child("\(user.user.uid).jpg")
//                    let data = self.photoImageView.image?.jpegData(compressionQuality: 0.5)
//                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metaData, error) in
//                        if error != nil {
//                            self.alertNotCorrectData(message: "\(error!.localizedDescription)")
//                            print(error!.localizedDescription)
//                        }
//
//                        imageRef.downloadURL(completion: { (url, error) in
//                            if error != nil {
//                                self.alertNotCorrectData(message: "\(error!.localizedDescription)")
//                                print(error!.localizedDescription)
//                            }
//
//                            if let url = url {
//                                let userInfo: [String: Any] = [
//                                    "uid": user.user.uid,
//                                    "full name": self.fullNameTextField.text!,
//                                    "urlToImage": url.absoluteString
//                                ]
//
//                                self.reference.child("users").child(user.user.uid).setValue(userInfo)
//
//                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
//                                self.present(vc, animated: true, completion: nil)
//                            }
//                        })
//                    })
//
//                    uploadTask.resume()
//
//                }
//            }
//        } else {
//            alertNotCorrectData(message: "Password not match.")
//            print("Password not match")
//        }
//
//
//        let alert = UIAlertController(title: "Success", message: "your message added to mail", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//        print("_______________________")
//        print("User is = \(user)")
//    }
//}
       
        //
        guard fullNameTextField.text != "", emailTextField.text != "", passwordTextField.text != "", confirmPasswordTextField.text != "" else {
                    self.alertNotCorrectData(message: "You entered not correct fields. Please try again.")
                    self.alertNotCorrectData(message: NSLocalizedString("notCorrectFields", comment: ""))
                    return
                }
    
        if passwordTextField.text == confirmPasswordTextField.text {
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
                            self.userPhotoImage.image?.jpegData(compressionQuality: 0.5)
                            let data = self.userPhotoImage.image?.jpegData(compressionQuality: 0.5)
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
        
                                        let alert = UIAlertController(title: "Success", message: "your message added to mail", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                                print("_______________________")
                                        userLogin.updateValue(self.phoneTextField.text!, forKey: self.userPhotoImage)
                                         print("User is = \(userLogin)")
                                    
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
}



extension SignUPFinalViewController :  UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func openLibrary(action:UIAlertAction!){
        imageController.sourceType = .photoLibrary
        imageController.allowsEditing = true
        present(imageController, animated: true, completion: nil)
    }
    
    func openCamera(action:UIAlertAction!){
        imageController.sourceType = .camera
        imageController.allowsEditing = true
        present(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageController.dismiss(animated: true,completion: nil)
        userPhotoImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            self.imageController.image = image
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//
    
}

extension SignUPFinalViewController {
    private func alertNotCorrectData(message: String) {
        let alert = UIAlertController(title: "OOPS!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
