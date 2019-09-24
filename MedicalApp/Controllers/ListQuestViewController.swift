//
//  ListQuestViewController.swift
//  MedicalApp
//
//  Created by Артем on 9/24/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class ListQuestViewController: UIViewController {
    
    @IBOutlet weak var qLabel: UILabel!
    @IBOutlet weak var questTextView: UITextView!
    
    var txt = "123"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.qLabel.text = txt
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
