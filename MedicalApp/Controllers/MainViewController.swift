//
//  MainViewController.swift
//  MedicalApp
//
//  Created by Артем Кармазь on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goBackButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
