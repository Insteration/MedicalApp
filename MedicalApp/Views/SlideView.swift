//
//  SlideView.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 10/4/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

//import Foundation
import UIKit
import WebKit

class SlideView: UIView {
    
    private var db = DB()
    
    // can remove var?
    private var labelName = UILabel()
    private var webView = WKWebView()
    private var slide = Slide()
    
//    init(frame frameSlide: CGRect, name: String, txtHTML: String, baseUrl: URL)
    init(_ slide: Slide, frameSlide: CGRect) {
        
        let frame = CGRect(x: 20, y: 50, width: frameSlide.width - 40, height: frameSlide.height - 100)
        
        // TODO: - all write in super init
        super.init(frame: frame)
        
        self.slide = slide
        prepareSlide(&self.slide)
        
        // need to make with guard
        let name = self.slide.name
        let html = self.slide.html ?? ""
        let baseUrl = self.slide.baseUrl ?? URL(string: "")
        
        print("super.init(frame: frame) =", frame)
        
        self.webView.frame = CGRect(x: 0, y: 100, width: frame.width, height: frame.height - 100)
        self.webView.loadHTMLString(html, baseURL: baseUrl)
        print("self.webView.frame =", self.webView.frame )
        
        self.labelName = createLabel(name)
        
        self.addSubview(self.labelName)
        self.addSubview(self.webView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SlideView {
    
    private func prepareSlide(_ slide: inout Slide) {
        
        let id = slide.id
        
        // TODO: - need to make with guard or if and use class for cell of the tableView
        let nameTopic = slide.nameTopic ?? "slide.nameTopic??"
        let name = slide.name
        let search = slide.search ?? ""
        
        let info = db.getInfoAboutDocForSlide(id)
        
        FM.checkDocSlide(info)
        
        let html = db.getHTML(id)
        
        let getUrlForSlide = FM.getUrlForSlide(id)
        print("getUrlForSlide = ", getUrlForSlide)
        
        FM.printListItemsFromDir(getUrlForSlide.path)
        
        let nameSlide = nameTopic + ": " + name + " - " + search
        
        slide = Slide(id: id, name: nameSlide, nameTopic: nameTopic, search: search, html: html, baseUrl: getUrlForSlide)
    }
}

// MARK: - create item for view
extension SlideView {
    
    private func createLabel(_ name: String) -> UILabel {
        
        let labelName = UILabel(frame: CGRect(x: 0, y: 0, width: 728, height: 80))
        labelName.font = .boldSystemFont(ofSize: 25)
        labelName.numberOfLines = 0
        labelName.textColor = .green
        labelName.backgroundColor = .lightGray
        labelName.textAlignment = .natural
        labelName.text = name
        labelName.sizeToFit()
        print("self.labelName.frame =", self.labelName.frame)
        
        return labelName
    }
}

/* code for output hmvl file in webview, before save it file in folder
 let getUrlHTMLFile = FM.getUrlHTMLFile(id: id, nameFile: name)
 FM.saveHTMLFile(html: html, url: getUrlHTMLFile)
 let request = URLRequest(url: getUrlHTMLFile)
 webView.load(request)
 webView.loadFileURL(getUrlHTMLFile, allowingReadAccessTo: getUrlHTMLFile) */
