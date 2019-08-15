//
//  VideoCollectionViewCell.swift
//  MedicalApp
//
//  Created by Артем on 8/15/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
    
    var videoItem: VideoLogo? {
        
        didSet {
            videoLabel.text = videoItem?.text
            if let image = videoItem?.image {
                videoImageView.image = UIImage(named: image)
            }
        }
    }
}
