//
//  LyricsLabel.swift
//  LyricsView
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

public class LyricsLabel: UIView {
    
    private let backgroundLabel = UILabel()
    private let sangLabel = UILabel()
    private var labels: [UILabel] {
        return [backgroundLabel, sangLabel]
    }
    
    private let sangLabelMask = CALayer()
    
    public var sangTextColor = UIColor.red {
        didSet {
            sangLabel.textColor = sangTextColor
        }
    }
    
    public var backgroundTextColor = UIColor.black {
        didSet {
            backgroundLabel.textColor = backgroundTextColor
        }
    }
    
    public var text: String = "" {
        didSet {
            labels.forEach{ $0.text = text }
            invalidateIntrinsicContentSize()
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            labels.forEach{ $0.font = font }
            invalidateIntrinsicContentSize()
        }
    }
    //MARK: Init / Deinit
    
    private func commonInit() {
        font = UIFont.systemFont(ofSize: 26)
        
        labels.forEach { (label) in
            addSubview(label)
        }
        
        sangLabel.textColor = sangTextColor
        backgroundLabel.textColor = backgroundTextColor
        sangLabelMask.anchorPoint = CGPoint(x: 0, y: 0.5)
        sangLabelMask.backgroundColor = UIColor.white.cgColor
        sangLabel.layer.mask = sangLabelMask
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override var intrinsicContentSize: CGSize {
        return backgroundLabel.intrinsicContentSize
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        sangLabelMask.bounds = CGRect(x: 0, y: 0, width: 0, height: bounds.height)
        sangLabelMask.position = CGPoint(x: 0, y: bounds.height / 2)
        labels.forEach{ $0.frame = bounds }
    }
    
    public func animate(intervals: [TimeInterval]) {

        let animation = CAKeyframeAnimation(keyPath: "bounds.size.width")
        var duration = 0.0
        var times = intervals.map { (time) -> TimeInterval in
            let newTime = duration
            duration += time
            return newTime
        }
        times.append(duration)
        
        var widths = [CGFloat]()
        if intervals.count == text.utf16.count {
            for index in 0...intervals.count {
                let substring = text.substring(to: text.index(text.startIndex, offsetBy: index))
                let size = substring.size(font: font)
                widths.append(size.width)
            }
        } else {
            
        }
        
        let timeLocations = times.map{ $0 / duration }
        animation.values = widths
        animation.keyTimes = timeLocations as [NSNumber]
        animation.duration = duration
        animation.calculationMode = kCAAnimationLinear
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        sangLabelMask.add(animation, forKey: "kLyrcisAnimation")
    }
}


