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
    
    init(id: Int = 0, name: String = "") {
        
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

struct DocSlide {
    
    var idSlide: Int
    var idDoc: Int
    var nameDoc: String
    
    init(idSlide: Int, idDoc: Int, nameDoc: String) {
        self.idSlide = idSlide
        self.idDoc = idDoc
        self.nameDoc = nameDoc
    }
}

struct Topic {
    var id: Int
    var name: String
}

// static? 
struct Topics {
    
    let listTopic: [Topic]
    
    init() {
        self.listTopic = DB().getTopics()
    }
    
}

struct SlidesInTopic {
    
    var listSlides: [Slide]
    
    init(_ idTopic: Int) {
        
        self.listSlides = DB().getNameSlidesInTopic(idTopic)
    }
    
}
