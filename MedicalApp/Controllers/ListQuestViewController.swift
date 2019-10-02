//
//  ListQuestViewController.swift
//  MedicalApp
//
//  Created by Артем on 9/24/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class ListQuestViewController: UIViewController {
    
    @IBOutlet weak var questTextView: UITextView!
        var txtQuestion = QuestionsAtribute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questTextView.text = txtQuestion.question
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
