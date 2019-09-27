//
//  ModelReport.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import Foundation




struct ReportData: Codable {
    var meatingData: [String]
    var peopleReports: [[String]]
    var isAccepted = [Bool]()
    var countPeoples: Int {
        get {
            return peopleReports.count
        }
    }
    
    init() {
        meatingData = [String]()
        peopleReports = [[String]]()
    }
}

let reportDataPickerEnglish = ["HCP visite", "Pharmacy visit", "Round table" ,"Clinical meeting", "Others"]

let reportDataPickerFransh = ["HCP visite1234", "Pharmacy visit1243", "Round table1234" ,"Clinical meeting1234", "Others1234"]
// "HCP visite / Pharmacy visit / Round table / Clinical meeting / Others",

let namesEnglish = ["Date of meeting",
             "Number of people",
             "Country",
             "City",
             "Commentaire",
             "visitType",
             "Name",
             "Last name",
             "Fonction",
             "Organisation",
             "Email",
             "Number",
             "Commentaire",
             "Accepted to contact et to receive Newsletter.",
             "LATER",
             "SEND",
             "Usage propre",
             "Report",
             "+",
             "Finish",
             "Warning",
             "Not all fields are filled",
             "Ok",
             "Are you sure you want to exit?",
             "Stay",
             "Exit",
             "Count reports",
             "Home"]

let namesFransh = ["Date of meeting1234",
                    "Number of people1234",
                    "Country1234",
                    "City1234",
                    "Commentaire1234",
                    "visitType1234",
                    "Name1234",
                    "Last name1234",
                    "Fonction1234",
                    "Organisation1234",
                    "Email1234",
                    "Number1234",
                    "Commentaire1234",
                    "Accepted to contact et to receive Newsletter.1234",
                    "LATER1234",
                    "SEND1234",
                    "Usage propre1234",
                    "Report1234",
                    "+1234",
                    "Finish1234",
                    "Warning1234",
                    "Not all fields are fille123d",
                    "Ok1234",
                    "Are you sure you want to exit?123",
                    "Stay1234",
                    "Exit123",
                    "Count reports1234",
                    "Home1234"]


enum namesId: Int {
    case dateOfMeeting
    case numberOfPeople
    case country
    case city
    case casecommentaire1
    case visitType
    case name
    case lastName
    case fonction
    case organisation
    case email
    case number
    case commentaire2
    //case allert
    case accept
    case buttonLater
    case buttonSend
    case butttonUsagePropre
    case report
    case buttonPlus
    case buttonFinish
    case warning
    case notAllFieldsAreFilled
    case ok
    case areYouSureYouWantToExit
    case stay
    case exit
    case countReports
    case home
}




var dataReport: [ReportData] {
    get {
        return UserDefaults.standard.structArrayData(ReportData.self, forKey: "ReportData")
    }
    set {
        UserDefaults.standard.setStructArray(newValue, forKey: "ReportData")
        UserDefaults.standard.synchronize()
    }
}
