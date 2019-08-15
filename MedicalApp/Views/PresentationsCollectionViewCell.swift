//
//  PresentationsCollectionViewCell.swift
//  MedicalApp
//
//  Created by Артем on 8/15/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class PresentationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var presentationsImageView: UIImageView!
    @IBOutlet weak var presentationsLabel: UILabel!
    
    var presentItem: PresentationLogo? {
        
        didSet {
            presentationsLabel.text = presentItem?.text
            
            if let image = presentItem?.image {
                presentationsImageView.image = UIImage(named: image)
                
            }
        }
    }
    
}
