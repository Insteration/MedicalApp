//
//  SlideView.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 10/4/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

//import Foundation
import UIKit
import WebKit

class SlideView: UIView {
    
    var labelName = UILabel()
    var webView = WKWebView()
    
    init(frame frameSlide: CGRect, name: String, txtHTML: String, baseUrl: URL) {
        
        // TODO: - all write in super init
        super.init(frame: frameSlide)
        print("super.init(frame: frame) =", frameSlide)
        
        self.webView.frame = CGRect(x: 0, y: 100, width: frameSlide.width, height: frameSlide.height - 100)
        self.webView.backgroundColor = .yellow
        self.webView.loadHTMLString(txtHTML, baseURL: baseUrl)
        print("self.webView.frame =", self.webView.frame )
        
        self.labelName = UILabel(frame: CGRect(x: 0, y: 0, width: frameSlide.width, height: 80))
        //        self.labelName.frame = CGRect(x: 0, y: 0, width: frame.width, height: 80)
        self.labelName.font = .boldSystemFont(ofSize: 20)
        self.labelName.numberOfLines = 0
        self.labelName.textColor = .green
        self.labelName.backgroundColor = .lightGray
        self.labelName.textAlignment = .center
        self.labelName.text = name
        self.labelName.sizeToFit()
        print("self.labelName.frame =", self.labelName.frame)
        
        self.addSubview(self.labelName)
        self.addSubview(self.webView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
