//
//  LibCollectiVC.swift
//  
//
//  Created by Alex Kholodoff on 9/30/19.
//

import UIKit

class LibCollectVCell: UICollectionViewCell {
        
    @IBOutlet weak var labelNameTopic: UILabel!
    
    var nameTopic: String? {
          didSet {
              labelNameTopic.text = nameTopic ?? "name Topic?"
            print("labelNameTopic.text = ", labelNameTopic.text!)
          }
      }
}
