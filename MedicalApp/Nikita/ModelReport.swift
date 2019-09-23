//
//  ModelReport.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import Foundation



//struct ReportData {
//    var numberOfPeople: String
//    var country: String
//    var city: String
//    var message1: String
//    var name: String
//    var lastName: String
//    var fonction: String
//    var organisation: String
//    var email: String
//    var number: String
//    var message2: String
//}






struct ReportData: Codable {
    var dateOfMeating: String
    var numberOfPeople: String
    var peopleReports: [[String]]
    var isAccepted = Bool()
    var countPeoples: Int {
        get {
            return peopleReports.count
        }
    }
    
    
    init() {
        dateOfMeating = ""
        numberOfPeople = ""
        peopleReports = [[String]]()
        
    }
}



let names = ["Date of meeting",
             "Number of people",
             "Country",
             "City",
             "Commentaire",
             "Name",
             "Last name",
             "Fonction",
             "Organisation",
             "Email",
             "Number",
             "Commentaire",
             "HCP visite / Pharmacy visit / Round table / Clinical meeting / Others",
             "Accepted to contact et to receive Newsletter.",
             "LATER",
             "SEND",
             "Usage propre",
             "Report",
             "+"]

enum namesId: Int {
    case dateOfMeeting
    case numberOfPeople
    case country
    case city
    case casecommentaire1
    case name
    case lastName
    case fonction
    case organisation
    case email
    case number
    case commentaire2
    case allert
    case accept
    case buttonLater
    case buttonSend
    case butttonUsagePropre
    case report
    case buttonPlus
}


