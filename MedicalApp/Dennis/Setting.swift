//
//  Setting.swift
//  MedicalApp
//
//  Created by Денис Андреев on 8/10/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class SettingsViewController : UIViewController {
    
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var changeP: UIButton!
    @IBOutlet weak var sendRequest: UIButton!
    @IBOutlet weak var phoneTex: UITextField!
    
    var imageController = UIImagePickerController()
    var timer: Timer!
    
    private func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(moveTimer), userInfo: nil, repeats: true)
    }
    
    @objc func moveTimer(){
        checkFields()
    }
    
    private func checkFields(){
        if phoneTex.text == "" {
            sendRequest.isEnabled = false
            sendRequest.alpha = 0.2
        } else {
            sendRequest.isEnabled = true
            sendRequest.alpha = 1
        }
    }
    
    
    private func changeStyle(){
        photoImage.layer.cornerRadius = self.photoImage.frame.size.width / 3.5
        photoImage.image  = UIImage(named: "question")
        photoImage.clipsToBounds = true
        photoImage.backgroundColor = .white
        changeP.backgroundColor = .white
        changeP.setTitle("Set Photo", for: .normal)
        changeP.layer.cornerRadius = 20
        sendRequest.layer.cornerRadius = 30
        imageController.delegate = self
        sendRequest.setTitle("Accept", for: .normal)
        sendRequest.backgroundColor = .white
        sendRequest.setTitleColor(.black, for: .normal)
        sendRequest.layer.cornerRadius = 30
    }
    
    override func viewDidLoad() {
        createTimer()
        changeStyle()
    }
    
    
    
    @IBAction func sendReqAction(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func photoChangeAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "User Photo", message: "choose photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: openCamera(action:)))
        alert.addAction(UIAlertAction(title: "Open Library", style: .default, handler: openLibrary(action:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: openLibrary(action:)))
        present(alert, animated: true, completion:nil)
    }
    
    
}

extension SettingsViewController :  UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func openLibrary(action:UIAlertAction!){
        imageController.sourceType = .photoLibrary
        imageController.allowsEditing = true
        present(imageController, animated: true, completion: nil)
    }
    
    func openCamera(action:UIAlertAction!){
        imageController.sourceType = .camera
        imageController.allowsEditing = true
        present(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageController.dismiss(animated: true,completion: nil)
        photoImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    
    
}
