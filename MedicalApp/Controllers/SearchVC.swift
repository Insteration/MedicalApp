//
//  SearchVCViewController.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 9/9/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    var db = DB()
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var lastTF: UITextField!
    
    @IBOutlet weak var searchBt: UIButton!
    @IBOutlet weak var reindexBt: UIButton!
    
    @IBOutlet weak var searchTv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
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

//        DispatchQueue.global(qos: .background).async {
//            let dbThread = self.db
//            var slideWord = String()
//
//            DispatchQueue.main.async {
//                for i in 6...6 {
//                    slideWord += dbThread.updateTXT(i)
//                    print("slide \(i) is done to table list_word")
//                }
//                self.libraryTextView.text = slideWord
//                //                print(slideWord)
//            }
//        }

// TODO: - make with thread only read DB
//        let html = db.getHTML(6)
//        libraryWebView.loadHTMLString(html, baseURL: nil)
