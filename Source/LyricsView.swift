//
//  LyricsView.swift
//  LyricsView
//
//  Created by Aqua on 21/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

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
    
    public var time: TimeInterval = 0 {
        didSet {
            tableView.indexPathsForVisibleRows?.forEach({ (indexPath) in
                if let lineModel = lyrics?.lines[indexPath.row],
                    let cell = tableView.cellForRow(at: indexPath) as? LyricsTableViewCell {
                    cell.lyricsLabel.currentTime = max(time - lineModel.beginTime, 0)
                }
            })
        }
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
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
        tableView.backgroundColor = .clear

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
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        tableView.separatorStyle  = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension LyricsView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyrics?.lines.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LyricsTableViewCell", for: indexPath) as! LyricsTableViewCell
        let lineModel = lyrics!.lines[indexPath.row]
        cell.lyricsLabel.text = lineModel.text
        cell.lyricsLabel.font = font
        cell.lyricsLabel.timeIntervals = lineModel.intervals
        cell.lyricsLabel.currentTime = max(time - lineModel.beginTime, 0)
        cell.lyricsLabel.shouldPrint = indexPath.row == 2
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
