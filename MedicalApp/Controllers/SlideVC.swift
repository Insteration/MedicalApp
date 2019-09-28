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
                
        lbSearch.text = slide.search ?? "search"
        
        print("getInfoAboutDocForSlide =  ", db.getInfoAboutDocForSlide(id))
        
        let html = db.getHTML(id)
        
        let getUrlForSlide = FM.getUrlForSlide(id)
        
        webView.loadHTMLString(html, baseURL: getUrlForSlide)
    }
    
}
