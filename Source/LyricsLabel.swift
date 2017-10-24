//
//  LyricsLabel.swift
//  LyricsView
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

public class LyricsLabel: UIView {

    // MARK: - Public Properties
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
    
    public var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            labels.forEach{ $0.font = font }
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    public var textAlignment: NSTextAlignment = .center {
        didSet {
            labels.forEach{ $0.textAlignment = textAlignment}
        }
    }
    
    public var timeIntervals: [TimeInterval] = [] {
        didSet {
            duration = timeIntervals.reduce(0, +)
        }
    }
    
    public var text: String = "" {
        didSet {
            labels.forEach{ $0.text = text }
        }
    }
    
    public var line: LyricsLineModelProtocol? {
        didSet {
            text = line?.text ?? ""
            timeIntervals = line?.intervals ?? []
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    public var currentTime: TimeInterval = 0.0 {
        didSet {
            updateLayerWidth()
        }
    }
    
    internal var isCurrentLine = false {
        didSet {
            widths = layerWidths()
            updateLayerWidth()
        }
    }
    
    // MARK: - Private Properties
    
    private let backgroundLabel = UILabel()
    private let sangLabel = UILabel()
    private var labels: [UILabel] {
        return [backgroundLabel, sangLabel]
    }
    
    fileprivate let sangLabelMask = CALayer()
    
    private var widths: [CGFloat] = []
    
    private var duration: TimeInterval = 0
    
    // MARK: - Init / Deinit
    
    private func commonInit() {
        font = UIFont.systemFont(ofSize: 40)
        textAlignment = .center
        
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
        sangLabelMask.bounds.size.height = bounds.height
        
        sangLabelMask.position = CGPoint(x: 0, y: bounds.height / 2)
        labels.forEach{ $0.frame = bounds }
    }
    
    fileprivate func layerWidths() -> [CGFloat] {
        
        /// only calculate widths when cell is current line
        guard isCurrentLine, let line = self.line else { return [] }
        var widths = [CGFloat]()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: paragraphStyle as NSParagraphStyle,
            ]
        
        let boundingSize = CGSize(width: bounds.width, height: bounds.height)
        
        func boundingRect(text: String) -> CGRect {
            return text.boundingRect(with: boundingSize,
                                     options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesDeviceMetrics],
                                     attributes: attributes,
                                     context: nil)
        }
        
        let maxRect: CGRect = boundingRect(text: text)
        
        var textOffset = 0
        widths.append(0)
        for index in 0..<line.characters.count {
            
            textOffset += line.characters[index].utf16.count
            let textIndex = text.index(text.startIndex, offsetBy: textOffset)
            
            let frontSubstring = text.substring(to: textIndex)
     
            let frontRect: CGRect = boundingRect(text: frontSubstring)
            
            let backSubstring = text.substring(from: textIndex)
            
            let backRect: CGRect = boundingRect(text: backSubstring)
            
            let width = frontRect.width + (maxRect.width - frontRect.width - backRect.width) / 2
            widths.append(width)
        }
        widths = widths.map{ $0 + maxRect.origin.x }
        widths.append(maxRect.maxX)
        
        return widths
    }
    
    private func updateLayerWidth() {
        
        guard isCurrentLine, let line = self.line else {
            // if this view is not current playing line
            sangLabelMask.bounds.size.width = 0
            return
        }
        
        var layerWidth: CGFloat = 0.0
        var currentIndex = 0
        var currentLetterTimeOffsetRatio = 0.0
        
        if currentTime <= line.beginTime {
            /// do nothing
        } else if currentTime > line.beginTime + duration {
            currentIndex = timeIntervals.count - 1
            currentLetterTimeOffsetRatio = 1
        } else {
            
            let lineTimeOffset = currentTime - line.beginTime
            var previousTimeOffset = 0.0

            for (index, timeInterval) in timeIntervals.enumerated() {
                
                if lineTimeOffset > previousTimeOffset && lineTimeOffset <= previousTimeOffset + timeInterval {
                    currentIndex = index
                    currentLetterTimeOffsetRatio = (lineTimeOffset - previousTimeOffset) / timeInterval
                    break
                }
                previousTimeOffset += timeInterval
            }
        }

        if widths.count > currentIndex {
            let letterOffset = widths[currentIndex]
            var nextLetterOffset: CGFloat = 0.0
            let nextIndex = currentIndex + 1
            if widths.count > nextIndex {
                nextLetterOffset = widths[nextIndex]
            }
            layerWidth = (nextLetterOffset - letterOffset) * CGFloat(currentLetterTimeOffsetRatio) + letterOffset
        }
        
        CATransaction.setDisableActions(true)
        sangLabelMask.bounds.size.width = layerWidth
    }
}

// MARK: - Public Methods
extension LyricsLabel {
    
    public func animate(intervals: [TimeInterval]) {
        
        var duration = 0.0
        var times = intervals.map { (time) -> TimeInterval in
            let newTime = duration
            duration += time
            return newTime
        }
        times.append(duration)
        
        animate(timeOffsets: times)
    }
    
    public func animate(timeOffsets: [TimeInterval]) {
        
        guard let duration = timeOffsets.last else { return }
        
        let animation = CAKeyframeAnimation(keyPath: "bounds.size.width")
        let timeOffsetRatios = timeOffsets.map{ $0 / duration }
        let widths = layerWidths()
        animation.values = widths
        animation.keyTimes = timeOffsetRatios as [NSNumber]
        animation.duration = duration
        animation.calculationMode = kCAAnimationLinear
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        sangLabelMask.add(animation, forKey: "kLyrcisAnimation")
    }
}
