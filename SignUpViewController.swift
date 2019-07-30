//
//  SignUpViewController.swift
//  MedicalApp
//
//  Created by Денис Андреев on 7/30/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//



import UIKit


class SignUPViewController: UIViewController, SignUp{
    
    var timer : Timer!
    var agree : Bool = false
    
    var photoButton : UIButton = {
        var button = UIButton()
        button.frame = CGRect(x: 20, y: 100, width: 374, height: 60)
        button.backgroundColor = .white
        button.setTitle("Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let nameTextField : UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.tintColor = .black
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 180, width: 374, height: 60)
        return textField
    }()
    
    let lastNameTextField : UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.tintColor = .black
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 260, width: 374, height: 60)
        return textField
    }()
    let fonctionTextField : UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Fonction", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.tintColor = .black
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 340, width: 374, height: 60)
        return textField
    }()
    let paysTextField : UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Pays", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.tintColor = .black
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 420, width: 374, height: 60)
        return textField
    }()
    let organizationTextField : UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "organisation", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.tintColor = .black
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 500, width: 374, height: 60)
        return textField
    }()
    let numberTextField : UITextField = {
        var textField = UITextField()
        textField.keyboardType = UIKeyboardType.phonePad
        textField.attributedPlaceholder = NSAttributedString(string: "Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.tintColor = .black
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 580, width: 374, height: 60)
        return textField
    }()
    let emailTextField : UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.tintColor = .black
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: 660, width: 374, height: 60)
        return textField
    }()
    
    var agreeButton : UIButton = {
        var button = UIButton()
        button.frame = CGRect(x: 40, y: 740, width: 30, height: 30)
        button.addTarget(self, action: #selector(checkPrivate), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    @objc func checkPrivate(){
        agree = !agree
        if agree {
            agreeButton.setTitle("✓", for: .normal)
            agreeButton.setTitleColor(.black, for: .normal)
        } else {
            agreeButton.setTitle(" ", for: .normal)
            agreeButton.setTitleColor(.black, for: .normal)
        }
    }
    
    private let agreeLabel : UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 90, y: 750, width: 300, height: 15)
        label.text = "Conditions generales appliation"
        return label
    }()
    
    
    var sendButton : UIButton = {
        var button = UIButton()
        button.frame = CGRect(x: 80, y: 790, width: 250, height: 50)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.setTitle("Send Request", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.alpha = 0.2
        return button
    }()
    
    
    fileprivate func addObjects() {
        self.view.addSubview(nameTextField)
        self.view.addSubview(lastNameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(organizationTextField)
        self.view.addSubview(paysTextField)
        self.view.addSubview(numberTextField)
        self.view.addSubview(fonctionTextField)
        self.view.addSubview(agreeButton)
        self.view.addSubview(agreeLabel)
        self.view.addSubview(sendButton)
        self.view.addSubview(photoButton)
    }
    
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerMoves), userInfo: nil, repeats: true)
    }
    
    @objc func timerMoves(){
        checkEmail(field: emailTextField)
        checkFields()
    }
    
    func checkFields(){
        let valid = isValidEmail(emailStr: emailTextField.text!)
        if nameTextField.text! != "" &&  lastNameTextField.text! != "" &&  fonctionTextField.text! != "" &&  paysTextField.text! != "" &&  organizationTextField.text! != "" &&  numberTextField.text! != "" && valid != false && agree != false{
            sendButton.alpha = 1.0
        } else {
            sendButton.alpha = 0.2
        }
    }
    
    
    override func viewDidLoad() {
        createTimer()
        addObjects()
    }
}



