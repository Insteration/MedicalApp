//
//  ReportViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var acceptSwitch: UISwitch!
    
    
    @IBOutlet weak var numberOfPeople: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var message1: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var fonction: UITextField!
    @IBOutlet weak var organisation: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var message2: UITextField!
    
    var reportData: [ReportData]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportData = [ReportData]()
        clearFields()
        customInit()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func pushLaterButton(_ sender: UIButton) {
        saveReportData()
        exitReport()
    }
    
    @IBAction func pushSendButton(_ sender: UIButton) {
        SendRepostData()
        exitReport()
    }
    
    @IBAction func pushNonButton(_ sender: UIButton) {
        exitReport()
    }
    
    @IBAction func pushButtonPlus(_ sender: UIButton) {
        if areAllFieldsFilled() {
            addReportIntoReportData()
            clearFields()
        } else {
            createAllert("Warning", "Not all fields are filled")
        }
    }
    
    
    
    private func customInit() {
        reportLabel.layer.masksToBounds = true;
        reportLabel.layer.cornerRadius = reportLabel.frame.height / 2
    }
    
    
    private func createAllert(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createAllertForExit() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to exit?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Stay", style: UIAlertAction.Style.default, handler: nil ))
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertAction.Style.destructive, handler: { action in
            print("exit report ok")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func exitReport() {
        createAllertForExit()
    }
    
    private func saveReportData() {
        if areAllFieldsFilled() {
            print("save data ok")
            clearFields()
        } else {
            createAllert("Warning", "Not all fields are filled")
        }
    }
    
    private func SendRepostData() {
        print("send data ok")
    }
    
    private func areAllFieldsFilled() -> Bool {
        if  numberOfPeople.text != "" &&
            country.text != "" &&
            city.text != "" &&
            message1.text != "" &&
            name.text != "" &&
            lastName.text != "" &&
            fonction.text != "" &&
            organisation.text != "" &&
            email.text != "" &&
            number.text != "" &&
            message2.text != "" &&
            acceptSwitch.isOn == true{
            return true
        }
        return false
    }
    
    private func clearFields() {
        numberOfPeople.text = ""
        country.text = ""
        city.text = ""
        message1.text = ""
        name.text = ""
        lastName.text = ""
        fonction.text = ""
        organisation.text = ""
        email.text = ""
        number.text = ""
        message2.text = ""
        
        acceptSwitch.isOn = false
    }
    
    private func addReportIntoReportData() {
        reportData.append(ReportData(
            numberOfPeople: numberOfPeople.text ?? "",
            country: country.text ?? "",
            city: city.text ?? "",
            message1: message1.text ?? "",
            name: name.text ?? "",
            lastName: lastName.text ?? "",
            fonction: fonction.text ?? "",
            organisation: organisation.text ?? "",
            email: email.text ?? "",
            number: number.text ?? "",
            message2: message2.text ?? ""
        ))
    }
    

}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
