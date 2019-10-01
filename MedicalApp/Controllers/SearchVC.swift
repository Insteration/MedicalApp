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
    let indentifier = "MyCell"
    var slides = [Slide]()

        
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var lastTF: UITextField!
    
    @IBOutlet weak var searchBt: UIButton!
    @IBOutlet weak var reindexBt: UIButton!
    
    @IBOutlet weak var searchTv: UITableView!
    
    override func viewDidLoad() {}
    
    @IBAction func btBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func btSearch(_ sender: UIButton) {
        
        guard let query = searchTF.text,
            query.count > 0  else { return }
        
        self.slides = []
        
        let arrWordSearch = db.splittingSearch(query)
        let querySql = db.prepareSearch(arrWordSearch)
        
        self.slides = db.searchSlides(querySql)
        print("slides = ", slides)
        
        searchTv.reloadData()
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
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTv.dequeueReusableCell(withIdentifier: indentifier, for: indexPath)
        
        let result = slides[indexPath.row].name
        cell.textLabel?.text = result
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let storyboard: UIStoryboard = UIStoryboard(name: "SlideVCSB", bundle: nil)
        let controller: SlideVC = storyboard.instantiateViewController(withIdentifier: "ControllerIdentifier") as! SlideVC
        
        controller.slide = slides[indexPath.row]
        
        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - reindex table slides_search
extension SearchVC {
    
    func reindex(from: Int = 0, to: Int = 0) {
        
        DispatchQueue.global(qos: .background).async {
            let dbThread = self.db
            
            DispatchQueue.main.async {
                for i in from...to {
                    dbThread.createDict(i)
                    print("slide \(i) is done to table slides_search")
                }
            }
        }
    }
    
}
