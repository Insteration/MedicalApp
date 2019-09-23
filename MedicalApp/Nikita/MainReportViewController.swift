//
//  MainReportViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 9/23/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit


class MainReportViewController: UIViewController {
    
    weak var collectionView: UICollectionView!
    
    var data = dataReport
    
    override func loadView() {
        super.loadView()
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
    }
}





extension MainReportViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
    
        cell.textLabel.text = self.data[indexPath.item].meatingData[namesId.dateOfMeeting.rawValue] + "/n"
//            + self.data[indexPath.item].
        cell.backgroundColor = .blue
        return cell
    }

}











class Cell: UICollectionViewCell {
    
    static var identifier: String = "Cell"
    
    var imageView: UIImageView!
    var textLabel: UILabel!
    var buttonFinish: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.backgroundColor = .blue
        customInit()
        self.reset()
    }
    
    private func customInit() {
        imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        contentView.addSubview(textLabel)
        textLabel.backgroundColor = .orange
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        
        buttonFinish = UIButton()
        contentView.addSubview(buttonFinish)
        buttonFinish.backgroundColor = .red
        buttonFinish.translatesAutoresizingMaskIntoConstraints = false
        buttonFinish.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        buttonFinish.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        buttonFinish.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        buttonFinish.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        buttonFinish.heightAnchor.constraint(equalTo: textLabel.heightAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
        self.textLabel.textAlignment = .center
    }
}









extension MainReportViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}





extension MainReportViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3 - 20
        return CGSize(width: size, height: size + size / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
