//
//  MainViewController.swift
//  MedicalApp
//
//  Created by Артем Кармазь on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var presentationCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
        
    var presentationLogoArray: [PresentationLogo] = { // <--- test
    var logo = PresentationLogo()
    logo.image = "cola"
    logo.text = "present100"

    var logo1 = PresentationLogo()
    logo1.image = "fanta"
    logo1.text = "present111"

    var logo2 = PresentationLogo()
    logo2.image = "fanta"
    logo2.text = "present222"

    var logo3 = PresentationLogo()
    logo3.image = "fanta"
    logo3.text = "present333"
        
    var logo4 = PresentationLogo()
    logo4.image = "fanta"
    logo4.text = "present4444"
        
    var logo5 = PresentationLogo()
    logo5.image = "fanta"
    logo5.text = "present555"

    var logo6 = PresentationLogo()
    logo6.image = "fanta"
    logo6.text = "present6"

    var logo7 = PresentationLogo()
    logo7.image = "fanta"
    logo7.text = "present7"

    var logo8 = PresentationLogo()
    logo8.image = "fanta"
    logo8.text = "present8"

    var logo9 = PresentationLogo()
    logo9.image = "fanta"
    logo9.text = "present9"

    var logo10 = PresentationLogo()
    logo10.image = "fanta"
    logo10.text = "present10"


    return [logo, logo1, logo2, logo3, logo4, logo5, logo6, logo7, logo8, logo9, logo10]
}()
    
    var videoLogoArray: [VideoLogo] = {
    var logo = VideoLogo()
    logo.image = "cola"
    logo.text = "video"

    var logo1 = VideoLogo()
    logo1.image = "fanta"
    logo1.text = "video1"

    var logo2 = VideoLogo()
    logo2.image = "cola"
    logo2.text = "video2"

    var logo3 = VideoLogo()
    logo3.image = "fanta"
    logo3.text = "video3"

    var logo4 = VideoLogo()
    logo4.image = "cola"
    logo4.text = "video4"

    var logo5 = VideoLogo()
    logo5.image = "fanta"
    logo5.text = "video5"

    var logo6 = VideoLogo()
    logo6.image = "cola"
    logo6.text = "video6"

    var logo7 = VideoLogo()
    logo7.image = "fanta"
    logo7.text = "video7"

    return [logo, logo1, logo2, logo3, logo4, logo5, logo6, logo7]
}()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goBackButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
