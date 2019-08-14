import UIKit

class PresentationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var presentationImageView: UIImageView!
    @IBOutlet weak var presentationLabel: UILabel!
    
    var presentItem: PresentationLogo? {
        
        didSet {
            presentationLabel.text = presentItem?.text
            
            if let image = presentItem?.image {
                presentationImageView.image = UIImage(named: image)
                
            }
        }
    }
}
