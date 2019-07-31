//
//   Data.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

 import Foundation

struct Const {
    
    let titleUserPhoto = loc("titleUserPhoto")
    let messageChoosePhoto = loc("messageChoosePhoto")
    let titleOpenCamera = loc("titleOpenCamera")
    let titleOpenLibrary = loc("titleOpenLibrary")
    let titleCancel = loc("titleCancel")
    
}

extension Const {
    private static func loc(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension String {
    func loc() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
