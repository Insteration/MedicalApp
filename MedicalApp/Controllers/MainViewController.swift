import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var presentationCollectionView: UICollectionView!
    
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    
    
    
//    var presentationLogoArray: [PresentationLogo] = { // <--- test
//        var logo = PresentationLogo()
//        logo.image = "cola"
//        logo.text = "PARAM-PAM-PAM"
//
//        var logo1 = PresentationLogo()
//        logo1.image = "fanta"
//        logo1.text = "Tuk-Tuk-Tuk"
//
//        var logo2 = PresentationLogo()
//        logo2.image = "fanta"
//
//        var logo3 = PresentationLogo()
//        logo3.image = "fanta"
//
//        var logo4 = PresentationLogo()
//        logo4.image = "fanta"
//
//        var logo5 = PresentationLogo()
//        logo5.image = "fanta"
//
//        var logo6 = PresentationLogo()
//        logo6.image = "fanta"
//
//        var logo7 = PresentationLogo()
//        logo7.image = "fanta"
//
//        var logo8 = PresentationLogo()
//        logo8.image = "fanta"
//
//        var logo9 = PresentationLogo()
//        logo9.image = "fanta"
//
//        var logo10 = PresentationLogo()
//        logo10.image = "fanta"
//
//
//        return [logo, logo1, logo2, logo3, logo4, logo5, logo6, logo7, logo8, logo9, logo10]
//    }()
//
//
//    var videoLogoArray: [VideoLogo] = {
//        var logo = VideoLogo()
//        logo.image = "cola"
//        logo.text = "video"
//
//        var logo1 = VideoLogo()
//        logo1.image = "fanta"
//        logo1.text = "video1"
//
//        var logo2 = VideoLogo()
//        logo2.image = "cola"
//        logo2.text = "video2"
//
//        var logo3 = VideoLogo()
//        logo3.image = "fanta"
//        logo3.text = "video3"
//
//        var logo4 = VideoLogo()
//        logo4.image = "cola"
//        logo4.text = "video4"
//
//        var logo5 = VideoLogo()
//        logo5.image = "fanta"
//        logo5.text = "video5"
//
//        var logo6 = VideoLogo()
//        logo6.image = "cola"
//        logo6.text = "video6"
//
//        var logo7 = VideoLogo()
//        logo7.image = "fanta"
//        logo7.text = "video7"
//
//        return [logo, logo1, logo2, logo3, logo4, logo5, logo6, logo7]
//    }()
//
//
////    @IBOutlet weak var userLogoButton: UIButton!
//
//
//    fileprivate func createUserLogoButton() {
//        self.userLogoButton.backgroundColor = .red
//        self.userLogoButton.setImage(UIImage(named: "cola"), for: .normal)
//        self.userLogoButton.layer.cornerRadius = 20
//        self.userLogoButton.contentMode = .scaleToFill
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        createUserLogoButton()
//    }
//
//    @IBAction func pendingReportButtonAction(_ sender: UIButton) {
//    }
//
//}
//
//extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        switch collectionView {
//        case presentationCollectionView:
//            return presentationLogoArray.count
//        case videoCollectionV:
//            return videoLogoArray.count
//        default: break
//        }
//
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch collectionView {
//        case presentationCollectionView:
//            let itemCell = presentationCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PresentationCollectionViewCell
//            itemCell?.presentItem = presentationLogoArray[indexPath.row]
//            return itemCell ?? UICollectionViewCell()
//
//        case videoCollectionV:
//            let videoItemCell = videoCollectionV.dequeueReusableCell(withReuseIdentifier: "Video", for: indexPath) as? VideoCollectionViewCell
//            videoItemCell?.videoItem = videoLogoArray[indexPath.row]
//            return videoItemCell ?? UICollectionViewCell()
//
//        default: break
//        }
//        return UICollectionViewCell()
//    }
    
}
