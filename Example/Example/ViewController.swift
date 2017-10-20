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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "1231中文中文"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sangTextColor = UIColor.blue
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func startAnimation() {
        label.animate(intervals:[0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 1, 0.5, ])
    }
}

