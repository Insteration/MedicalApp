//
//  SearchVCViewController.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 9/9/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

// CREATE VIRTUAL TABLE "slides_search" USING FTS5 ( id , id_slide , cnt , word , list_word );
import UIKit

class SearchVC: UIViewController {

    var db = DB()
    let indentifier = "MyCell"
    var array = [String]()
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var lastTF: UITextField!
    
    @IBOutlet weak var searchBt: UIButton!
    @IBOutlet weak var reindexBt: UIButton!
    
    @IBOutlet weak var searchTv: UITableView!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func btSearch(_ sender: UIButton) {
        
        guard let query = searchTF.text,
            query.count > 0  else { return }
        
        array = []
        
        let arrWordSearch = db.splittingSearch(query)
        let querySql = db.prepareSearch(arrWordSearch)
        array = db.searchSlides(querySql)
        
        searchTv.reloadData()
        print(array)
        
    }
    
    @IBAction func btReindex(_ sender: UIButton) {
        
        let from = Int(firstTF.text!) ?? 0
        let to = Int(lastTF.text!) ?? 0
        
        guard to >= from else {
            return
        }
        
        reindex(from: from, to: to)
    }
    
 
}

// TODO: - make with thread only read DB
//        let html = db.getHTML(6)
//        libraryWebView.loadHTMLString(html, baseURL: nil)

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTv.dequeueReusableCell(withIdentifier: indentifier, for: indexPath)
        
        let number = array[indexPath.row]
        cell.textLabel?.text = number
        return cell
    }

}

// MARK: - reindex table slides_search
extension SearchVC {
    
    func reindex(from: Int = 0, to: Int = 0) {
        
        DispatchQueue.global(qos: .background).async {
            let dbThread = self.db
            //            var slideWord = String()
            
            DispatchQueue.main.async {
                for i in from...to {
                    dbThread.createDict(i)
                    print("slide \(i) is done to table slides_search")
                }
                //                self.libraryTextView.text = slideWord
                //                print(slideWord)
            }
        }
    }
    
}
