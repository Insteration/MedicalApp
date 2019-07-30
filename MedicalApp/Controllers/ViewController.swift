//
//  ViewController.swift
//  MedicalApp
//
//  Created by Артём Кармазь on 7/29/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let sigIN = SignINViewControllerXIB(nibName: "SignINViewControllerXIB", bundle: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.present(sigIN, animated: true, completion: nil)
        
    }


}

