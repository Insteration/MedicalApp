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

let reportDataPicker = ["HCP visite", "Pharmacy visit", "Round table" ,"Clinical meeting", "Others"]

let names = ["Date of meeting",
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
             "HCP visite / Pharmacy visit / Round table / Clinical meeting / Others",
             "Accepted to contact et to receive Newsletter.",
             "LATER",
             "SEND",
             "Usage propre",
             "Report",
             "+",
             "Finish"]

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
    case allert
    case accept
    case buttonLater
    case buttonSend
    case butttonUsagePropre
    case report
    case buttonPlus
    case buttonFinish
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
