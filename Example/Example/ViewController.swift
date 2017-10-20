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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = LyricsLabel()
        label.text = "123123"
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

