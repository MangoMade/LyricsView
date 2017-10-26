//
//  LyricsTableViewCell.swift
//  LyricsView
//
//  Created by Aqua on 21/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

class LyricsTableViewCell: UITableViewCell {
    
    let lyricsLabel = LyricsLabel()
    
    private func commonInit() {
        selectionStyle = .none
        
        contentView.backgroundColor = UIColor.clear
        
        backgroundColor = UIColor.clear
        
        lyricsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lyricsLabel)
        let centerEdges: [NSLayoutAttribute] = [.centerY, .centerX]
        centerEdges.forEach { (edge) in
            NSLayoutConstraint(item: lyricsLabel,
                               attribute: edge,
                               relatedBy: .equal,
                               toItem: contentView,
                               attribute: edge,
                               multiplier: 1,
                               constant: 0).isActive = true
        }
        
        NSLayoutConstraint(item: lyricsLabel,
                           attribute: .left,
                           relatedBy: .greaterThanOrEqual,
                           toItem: contentView,
                           attribute: .left,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: lyricsLabel,
                           attribute: .left,
                           relatedBy: .lessThanOrEqual,
                           toItem: contentView,
                           attribute: .left,
                           multiplier: 1,
                           constant: 0).isActive = true
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
