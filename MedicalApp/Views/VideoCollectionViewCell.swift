import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoLable: UILabel!
    
    var videoItem: VideoLogo? {
        
        didSet {
            videoLable.text = videoItem?.text
            
            if let image = videoItem?.image {
                videoImageView.image = UIImage(named: image)
            }
        }
    }
}
