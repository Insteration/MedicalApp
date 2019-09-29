//
//  SlideVC.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 9/25/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit
import WebKit

class SlideVC: UIViewController {
    
    var db = DB()
    var slide = Slide()
    
    @IBOutlet weak var lbSearch: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func btBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {}
    
    override func viewWillAppear(_ animated: Bool) {
        
        let id = self.slide.id
        
        self.navigationItem.title = slide.name
        
        // TODO: - need to make with guard or if and use class for cell of the tableView
        let nameTopic = slide.nameTopic ?? "slide.nameTopic"
        let name = slide.name
        let search = slide.search ?? "search"
        lbSearch.text = nameTopic + ": " + name + " - " + search
        
        let info = db.getInfoAboutDocForSlide(id)
        
        FM.checkDocSlide(info)
        
        let html = db.getHTML(id)
                
        let getUrlForSlide = FM.getUrlForSlide(id)
        print("getUrlForSlide = ", getUrlForSlide)
        
        let getUrlHTMLFile = FM.getUrlHTMLFile(id: id, nameFile: name)
        FM.saveHTMLFile(html: html, url: getUrlHTMLFile)
        
        FM.printListItemsFromDir(getUrlForSlide.path)
        
        let request = URLRequest(url: getUrlHTMLFile)
        webView.load(request)
        webView.loadFileURL(getUrlHTMLFile, allowingReadAccessTo: getUrlHTMLFile)
        //        webView.loadHTMLString(html, baseURL: getUrlForSlide)
    }
    
}
