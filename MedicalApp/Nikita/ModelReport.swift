//
//  ModelReport.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import Foundation




//struct ReportData: Codable {
//    var meatingData: [String]
//    var peopleReports: [[String]]
//    var isAccepted = [Bool]()
//    var countPeoples: Int {
//        get {
//            return peopleReports.count
//        }
//    }
//
//    init() {
//        meatingData = [String]()
//        peopleReports = [[String]]()
//    }
//}


struct Report: Codable {
    var meatingData: String
    var numberOfPeople: String
    var meatingType: String
    var country: String
    var city: String
    var comment: String
    var people: [Person]
    
    init() {
        meatingData = ""
        numberOfPeople = ""
        meatingType = ""
        country = ""
        city = ""
        comment = ""
        people = [Person]()
    }
}

struct Person: Codable {
    var name: String
    var lastName: String
    var function: String
    var organization: String
    var email: String
    var phone: String
    var comment: String
    var isAccept: Bool
    
    init() {
        name = ""
        lastName = ""
        function = ""
        organization = "10"
        email = "11"
        phone = "12"
        comment = "13"
        isAccept = false
    }
}

var dataReport: [Report] {
    get {
        return UserDefaults.standard.structArrayData(Report.self, forKey: "ReportData")
    }
    set {
        UserDefaults.standard.setStructArray(newValue, forKey: "ReportData")
        UserDefaults.standard.synchronize()
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
    case commentaire1
    case visitType
    case name
    case lastName
    case function
    case organisation
    case email
    case phone
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





