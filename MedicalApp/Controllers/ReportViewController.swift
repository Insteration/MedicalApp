//
//  ReportViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var numberOfPeopleLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var message1Label: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var fonctionLabel: UITextField!
    @IBOutlet weak var organisationLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var numberLabel: UITextField!
    @IBOutlet weak var message2Label: UITextField!
    
    var reportData: [ReportData]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportData = [ReportData]()
        clearLabels()
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
            clearLabels()
        } else {
            createAllert("Warning", "Not all fields are filled")
        }
    }
    
    
    
    private func createAllert(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func exitReport() {
        print("exit report ok")
    }
    
    private func saveReportData() {
        print("save data ok")
    }
    
    private func SendRepostData() {
        print("send data ok")
    }
    
    private func areAllFieldsFilled() -> Bool {
        if  numberOfPeopleLabel.text != "" &&
            countryLabel.text != "" &&
            cityLabel.text != "" &&
            message1Label.text != "" &&
            nameLabel.text != "" &&
            lastNameLabel.text != "" &&
            fonctionLabel.text != "" &&
            organisationLabel.text != "" &&
            emailLabel.text != "" &&
            numberLabel.text != "" &&
            message2Label.text != "" {
            return true
        }
        return false
    }
    
    private func clearLabels() {
        numberOfPeopleLabel.text = ""
        countryLabel.text = ""
        cityLabel.text = ""
        message1Label.text = ""
        nameLabel.text = ""
        lastNameLabel.text = ""
        fonctionLabel.text = ""
        organisationLabel.text = ""
        emailLabel.text = ""
        numberLabel.text = ""
        message2Label.text = ""
    }
    
    private func addReportIntoReportData() {
        reportData.append(ReportData(
            numberOfPeople: numberOfPeopleLabel.text ?? "",
            country: countryLabel.text ?? "",
            city: cityLabel.text ?? "",
            message1: message1Label.text ?? "",
            name: nameLabel.text ?? "",
            lastName: lastNameLabel.text ?? "",
            fonction: fonctionLabel.text ?? "",
            organisation: organisationLabel.text ?? "",
            email: emailLabel.text ?? "",
            number: numberLabel.text ?? "",
            message2: message2Label.text ?? ""
        ))
    }
    

}
