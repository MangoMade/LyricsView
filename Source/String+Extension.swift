//
//  String+Extension.swift
//  LyricsView
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

extension String {
    
    func size(font: UIFont,
              size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                    height: CGFloat.greatestFiniteMagnitude)) -> CGSize {
        let attributes = [NSAttributedStringKey.font: font]
        let rect: CGRect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size
    }
}
