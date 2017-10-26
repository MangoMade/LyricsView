//
//  LyricsView.swift
//  LyricsView
//
//  Created by Aqua on 21/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

public enum LyricsAlignment {
    case center
    case top
    case bottom
    
    fileprivate var scrollPosition: UITableViewScrollPosition {
        switch self {
        case .center:
            return .middle
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
}

public class LyricsView: UIView {
    
    public var lyrics: LyricsModelProtocol? {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var lineHeight: CGFloat = 40 {
        didSet {
            tableView.rowHeight = lineHeight
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var currentLineFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    public var currentLineBackgroundTextColor: UIColor = UIColor.black
    
    public var time: TimeInterval = 0 {
        didSet {
            updateProgress()
        }
    }
    
    public var alignment = LyricsAlignment.center {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var displayUpdated: ((LyricsView) -> Void)?
    
    public var sangTextColor = UIColor.red {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var backgroundTextColor = UIColor.black {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var currentLineIndex = -1 {
        willSet {
            
            let newCurrentLineIndexPath = IndexPath(row: newValue, section: 0)
            if !tableView.isDragging && !tableView.isTracking {
                /// if currentLineIndex < 0, don't animate.
                let animated = currentLineIndex >= 0
                tableView.scrollToRow(at: newCurrentLineIndexPath, at: alignment.scrollPosition, animated: animated)
            }
            /// change the previous current line's font to normal font
            let currentLineIndexPath = IndexPath(row: currentLineIndex, section: 0)
            if let cell = tableView.cellForRow(at: currentLineIndexPath) as? LyricsTableViewCell {
                cell.lyricsLabel.backgroundTextColor = backgroundTextColor
                cell.lyricsLabel.font = font
                cell.lyricsLabel.isCurrentLine = false
            }
            /// change the current line's font
            if let cell = tableView.cellForRow(at: newCurrentLineIndexPath) as? LyricsTableViewCell {
                cell.lyricsLabel.backgroundTextColor = currentLineBackgroundTextColor
                cell.lyricsLabel.font = currentLineFont
                cell.lyricsLabel.isCurrentLine = true
            }
        }
    }
    
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var displayLink: CADisplayLink?
    
    //MARK: Init / Deinit
    
    private func commonInit() {
        
        backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.register(LyricsTableViewCell.self, forCellReuseIdentifier: "LyricsTableViewCell")
        tableView.estimatedRowHeight = 0
        tableView.rowHeight          = lineHeight
        
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        addSubview(tableView)
        let edges: [NSLayoutAttribute] = [.top, .bottom, .left, .right]
        edges.forEach { (edge) in
            NSLayoutConstraint(item: tableView,
                               attribute: edge,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: edge,
                               multiplier: 1,
                               constant: 0).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let inset = (bounds.height - lineHeight) / 2
        switch alignment {
        case .center:
            tableView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        case .top:
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset * 2, right: 0)
        case .bottom:
            tableView.contentInset = UIEdgeInsets(top: inset * 2, left: 0, bottom: 0, right: 0)
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        tableView.separatorStyle  = .none
        tableView.backgroundColor    = .clear
        
        if superview != nil {
            displayLink = CADisplayLink(target: self, selector: #selector(update))
            displayLink?.add(to: RunLoop.current, forMode: .commonModes)
        } else {
            displayLink?.invalidate()
        }
    }
    
    @objc func update() {
        displayUpdated?(self)
    }
}

/// MARK: Private Methods
extension LyricsView {
    
    fileprivate func updateProgress() {
        
        guard let lyrics = self.lyrics else { return }
        
        func isCurrentLine(lineIndex: Int) -> Bool {
            let lastLineIndex = lineIndex + 1
            let isLastLine = lyrics.lines.count == lastLineIndex
            let line = lyrics.lines[lineIndex]
            if isLastLine && time > line.beginTime {
                return true
            } else if time > line.beginTime && lyrics.lines[lastLineIndex].beginTime >= time {
                return true
            }
            return false
        }
        
        /// find out index of current line
        var lineIndex = 0
        if currentLineIndex >= 0 && isCurrentLine(lineIndex: currentLineIndex) {
            lineIndex = currentLineIndex
        } else {
            /// if current time is not in current line
            for index in 0..<lyrics.lines.count {
                if isCurrentLine(lineIndex: index) {
                    lineIndex = index
                    break
                }
            }
        }
        
        /// update cell's time
        if lineIndex != self.currentLineIndex {
            currentLineIndex = lineIndex
        }
        let currentLineIndexPath = IndexPath(row: currentLineIndex, section: 0)
        if let cell = tableView.cellForRow(at: currentLineIndexPath) as? LyricsTableViewCell {
            cell.lyricsLabel.currentTime = max(time, 0)
        }
    }
}

extension LyricsView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyrics?.lines.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LyricsTableViewCell", for: indexPath) as! LyricsTableViewCell
        let lineModel = lyrics!.lines[indexPath.row]
        let isCurrentLine = indexPath.row == currentLineIndex
        cell.lyricsLabel.font = isCurrentLine ? currentLineFont : font
        
        cell.lyricsLabel.line = lineModel
        cell.lyricsLabel.currentTime = max(time, 0)
        cell.lyricsLabel.sangTextColor = sangTextColor
        cell.lyricsLabel.backgroundTextColor = isCurrentLine ? currentLineBackgroundTextColor : backgroundTextColor
        
        cell.lyricsLabel.isCurrentLine = isCurrentLine
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

}

extension LyricsView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
