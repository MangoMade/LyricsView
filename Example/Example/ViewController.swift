//
//  ViewController.swift
//  Example
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit
import LyricsView

class ViewController: UIViewController {

    let label = LyricsLabel()
    
    let lyricsView = LyricsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        label.text = "1231中文中文"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sangTextColor = UIColor.blue
        label.backgroundTextColor = UIColor.lightGray
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1

        view.addSubview(label)
        NSLayoutConstraint(item: label,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 100).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 100).isActive = true

        
        let button = UIButton(type: .system)
        button.setTitle("start", for: .normal)
        button.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint(item: button,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: button,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 100).isActive = true
         */
        lyricsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lyricsView)
        NSLayoutConstraint(item: lyricsView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: lyricsView,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: lyricsView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: UIScreen.main.bounds.width).isActive = true
        
        NSLayoutConstraint(item: lyricsView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 300).isActive = true
        
        let fileName = "test2.ksc"
        guard let lrcFilePath = Bundle.main.path(forResource: fileName, ofType: nil)  else { return }
        let lrcContent = try! String(contentsOfFile: lrcFilePath, encoding: .utf8)
        
        let model = KSCPaser(with: lrcContent).generateModel()
        lyricsView.lyrics = model
        

    }

    @objc func startAnimation() {
        label.animate(intervals:[0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 1, 0.5, ])
    }
}

