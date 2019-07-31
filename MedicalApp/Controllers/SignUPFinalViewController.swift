//
//  SignUPFinalViewController.swift
//  MedicalApp
//
//  Created by Денис Андреев on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class SignUPFinalViewController: UIViewController {
    
    var agree: Bool = false
    var timer:Timer!
    var imageController = UIImagePickerController()
    
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var paysTextField: UITextField!
    @IBOutlet weak var organistaiontextField: UITextField!
    @IBOutlet weak var fonctionTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var userPhotoImage: UIImageView!
    
    func changeObjects(){
        userPhotoImage.layer.cornerRadius = self.userPhotoImage.frame.size.width / 3.5
        userPhotoImage.image  = UIImage(named: "question")
        userPhotoImage.clipsToBounds = true
        userPhotoImage.backgroundColor = .white
        photoButton.backgroundColor = .white
        photoButton.setTitle("Set Photo", for: .normal)
        photoButton.layer.cornerRadius = 20
        sendButton.layer.cornerRadius = 30
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        fonctionTextField.attributedPlaceholder = NSAttributedString(string: "Fonction", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        organistaiontextField.attributedPlaceholder = NSAttributedString(string: "Organisation", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        paysTextField.attributedPlaceholder = NSAttributedString(string: "Pays", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        numberTextField.attributedPlaceholder = NSAttributedString(string: "Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerMoves), userInfo: nil, repeats: true)
    }
    @objc func timerMoves(){
        let number = numberTextField.text!
        number.checkNumber(field: numberTextField)
        let email:String = emailTextField.text!
        email.checkEmail(field: emailTextField)
        checkFields()
    }
    
    func checkFields(){
        let email : String = emailTextField.text!
        let emailBool = email.isValidEmail(emailStr: email)
        let phone : String = numberTextField.text!
        let phoneBool = phone.validate(value: phone)
        
        if nameTextField.text! != "" &&  lastNameTextField.text! != "" &&  fonctionTextField.text! != "" &&  paysTextField.text! != "" &&  organistaiontextField.text! != "" &&   agree != false && emailBool && phoneBool && userPhotoImage.image != UIImage(named: "question")  {
            sendButton.alpha = 1.0
            sendButton.isEnabled = true
        } else {
            sendButton.alpha = 0.2
            sendButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        imageController.delegate = self
        createTimer()
        changeObjects()
    }
    
    @IBAction func agreeButtonAction(_ sender: Any) {
        agree = !agree
        if agree {
            agreeButton.setTitle("✓", for: .normal)
            agreeButton.setTitleColor(.black, for: .normal)
        } else {
            agreeButton.setTitle(" ", for: .normal)
            agreeButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBAction func photoButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "User Photo", message: "choose photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: openCamera(action:)))
        alert.addAction(UIAlertAction(title: "Open Library", style: .default, handler: openLibrary(action:)))
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: openLibrary(action:)))
        present(alert, animated: true, completion:nil)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Success", message: "your message added to mail", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
}
