//
//  ViewController.swift
//  Example
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? LyricsViewController {
            if segue.identifier == "lrc" {
                vc.fileType = .lrc
            } else if segue.identifier == "ksc" {
                vc.fileType = .ksc
            }
        }
    }

}

