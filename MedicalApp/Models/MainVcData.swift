//
//  MainVcData.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 8/15/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

//import Foundation

struct PresentationLogo {
    var image: String?
    var text: String?
}

struct VideoLogo {
    var image: String?
    var text: String?
}


struct Slide {
    
    var id: Int
    var name: String
    var nameTopic: String?
    var html: String?
    var search: String?
    
    init(id: Int, name: String) {
        
        self.id = id
        self.name = name
    }
    
    init(id: Int, name: String, nameTopic: String) {
        
        self.id = id
        self.name = name
        self.nameTopic = nameTopic
    }
    
    // init for save result of searh
    init(id: Int, name: String, nameTopic: String, search: String) {
        
        self.id = id
        self.name = name
        self.nameTopic = nameTopic
        self.search = search
    }
    
    
    // ceate more init for any cases
    
}



struct Test {
    
    
    func testPrintSlide() {
        
        let slide = Slide(id: 1, name: "xcv")
        print(slide)
    }
}
