//
//  CollectionViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 8/5/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    @IBOutlet weak var collection: UITableView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    
    var data: [CollectionData]!
    private let cellReuseIdentifier = "collectionCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.dataSource = self
        self.collection.delegate = self
        data = [CollectionData(name: "marketing 1", items: ["marketing offline 11","marketing offline 12","marketing offline 13"])]
        data.append(CollectionData(name: "marketing 2", items: ["marketing offline 21","marketing offline 22","marketing offline 23"]))
        data.append(CollectionData(name: "marketing 3", items: ["marketing offline 31","marketing offline 32","marketing offline 33"]))
        data.append(CollectionData(name: "marketing 4", items: ["marketing offline 41","marketing offline 42","marketing offline 43"]))
        data.append(CollectionData(name: "marketing 5", items: ["marketing offline 51","marketing offline 52","marketing offline 53"]))
        
        btnOk.layer.masksToBounds = true;
        btnOk.layer.cornerRadius = btnOk.frame.height / 2
    }
    
    
    
    
}


extension CollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    //    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x:20, y: 10, width: collection.frame.width - 40, height: 45)
        myLabel.font = UIFont.boldSystemFont(ofSize: 30)
        myLabel.text = data[section].name //self.collection(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    //    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //        return data[section].name
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        //        label.font = UIFont(name: label.font.fontName, size: 20)
        
        cell!.textLabel!.text = data[indexPath.section].items[indexPath.row]
        cell!.textLabel!.font = UIFont(name: cell!.textLabel!.font.fontName, size: 20)
        return cell!
    }
    
    
}


//
//struct CollectionData {
//    var name: String
//    var items: [String]
//}
