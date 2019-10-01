//  LibCollectiVC.swift
//
//
//  Created by Alex Kholodoff on 9/30/19.

import UIKit

class LibCollectionVCell: UICollectionViewCell {
    
    @IBOutlet weak var labelNameTopic: UILabel!
    @IBOutlet weak var tvSlides: UITableView!
    
    @IBOutlet weak var labelNameSlide: UILabel!
    var listSlides = [Slide]()
    let cellInd = "CellSlide"
    
    var topic: Topic? {
        didSet {
            labelNameTopic.text = topic?.name ?? "name Topic?"
            
            self.listSlides = SlidesInTopic(topic!.id).listSlides
            print("Topic :", topic?.name ?? "name Topic?")
            self.listSlides.forEach{
                print("id slide =", $0.id, ", name slide =", $0.name)
            }
        }
    }
    
    override func layoutSubviews()
       {
           super.layoutSubviews()
           tvSlides.delegate = self
           tvSlides.dataSource = self
       }
}

extension LibCollectionVCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.listSlides.count
        print("let count = self.listSlides.count =", count)
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("indexPath.row =", indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellInd)!
        let object = listSlides[indexPath.row].name
//        print("listSlides[indexPath.row].name =", object)
        cell.textLabel?.text = object
        print("cell.textLabel?.text =", cell.textLabel?.text ?? " empty!!! ")
//        cell.labelNameSlide.text = object
//        print("cell.textLabel?.text =", cell.textLabel?.text ?? " empty!!! ")
        return cell
    }
    
}
