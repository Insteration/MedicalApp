//
//  ReportCollectionViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 9/26/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "Cell"
fileprivate let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"
fileprivate var names = namesEnglish

class ReportCollectionViewController: UICollectionViewController {
    
    var homeButton = UIButton()
    var buttons = [UIButton]()
    
    var data = dataReport
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current.languageCode
        if locale == "fr" {
            names = namesFransh
        }
        
        
        for _ in 0..<self.data.count {
            buttons.append(UIButton())
        }
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            ])
        self.collectionView = collectionView
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        collectionView.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        customInit(&cell, indexPath.item)
        
        return cell
    }
    
    @objc func buttonHomePress(_ selector: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}





extension ReportCollectionViewController {
    private func customInit(_ cell: inout UICollectionViewCell, _ indexPath: Int) {
        var imageView: UIImageView!
        var textLabel: UILabel!
        var buttonFinish: UIButton!
        
        imageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 40).isActive = true
        imageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 8).isActive = true
        imageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -8).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.image = UIImage(named: "cola")
        imageView.contentMode = .scaleAspectFill
        
        
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        cell.contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 8).isActive = true
        textLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 8).isActive = true
        textLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -8).isActive = true
        textLabel.text = self.data[indexPath].meatingType + "\n"
            + self.data[indexPath].meatingData
        
        
        buttonFinish = UIButton()
        cell.contentView.addSubview(buttonFinish)
        buttonFinish.backgroundColor = .blue
        buttonFinish.translatesAutoresizingMaskIntoConstraints = false
        buttonFinish.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        buttonFinish.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 8).isActive = true
        buttonFinish.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -8).isActive = true
        buttonFinish.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 8).isActive = true
        buttonFinish.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        buttonFinish.setTitle(names[namesId.buttonFinish.rawValue], for: .normal)
        buttons[indexPath] = buttonFinish
        buttonFinish.titleLabel?.textColor = .black
        buttonFinish.layer.cornerRadius = 15
        
        
    }
}





extension ReportCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath) as! MyHeaderFooterClass
            headerView.homeButton.addTarget(self, action: #selector(buttonHomePress), for: .touchUpInside)
            return headerView
        } else {
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80.0)
    }
}





extension ReportCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = 120
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}





class MyHeaderFooterClass: UICollectionReusableView {
    var homeButton = UIButton()
    var textLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    private func customInit() {
        self.addSubview(homeButton)
        self.addSubview(textLabel)
        
        textLabel.text = "\(names[namesId.countReports.rawValue]) - \(dataReport.count)/10"
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        textLabel.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -10).isActive = true
        textLabel.leftAnchor.constraint(equalTo: homeButton.rightAnchor, constant: 10).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        
        homeButton.setTitle(names[namesId.home.rawValue], for: .normal)
        homeButton.backgroundColor = .red
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        homeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        homeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        homeButton.widthAnchor.constraint(equalTo: homeButton.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
}
