//
//  SignUpProtocol.swift
//  MedicalApp
//
//  Created by Денис Андреев on 7/30/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

protocol SignUp {
    func isValidEmail(emailStr:String) -> Bool
    func checkEmail(field : UITextField)
    
}

extension SignUp {
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func checkEmail(field : UITextField) {
        let email = isValidEmail(emailStr: field.text!)
        if email{
            field.tintColor = .green
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.green.cgColor
        }  else if field.text! == ""{
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.white.cgColor
        }
            else {
            field.tintColor = .red
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.red.cgColor
        }
    }

}
