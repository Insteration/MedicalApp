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
    
    var id = 1
    var search = String()
    var db = DB()
    
    @IBOutlet weak var lbSearch: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func btBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SlideVC")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "name slide"
        
        lbSearch.text = search
        
        let html = db.getHTML(id)
        let documentsDirectoryURL = FM.documentsDirectoryURL
        //        print("documentsDirectoryURL = ", documentsDirectoryURL)
        
        //        libraryWebView.allow
        webView.loadHTMLString(html, baseURL: documentsDirectoryURL)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
