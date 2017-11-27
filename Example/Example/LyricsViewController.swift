//
//  LyricsViewController.swift
//  Example
//
//  Created by Aqua on 27/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit
import LyricsView
import AVFoundation

enum LyricsFileType {
    
    case lrc
    case ksc
}

class LyricsViewController: UIViewController {

    private var lyricsView: LyricsView? = LyricsView()
    private var player: AVAudioPlayer?
    
    var fileType: LyricsFileType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let lyricsView = self.lyricsView else { return }
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
                           constant: 180).isActive = true
        
        var model: LyricsModel!
        
        if fileType == .lrc {
            
            let fileName = "BeautifulLove.lrc"
            guard let lrcFilePath = Bundle.main.path(forResource: fileName, ofType: nil)  else { return }
            let lrcContent = try! String(contentsOfFile: lrcFilePath, encoding: .utf8)
            model = LRCPaser(with: lrcContent).generateModel()
        } else if fileType == .ksc {
            
            let fileName = "BeautifulLove.ksc"
            guard let lrcFilePath = Bundle.main.path(forResource: fileName, ofType: nil)  else { return }
            let lrcContent = try! String(contentsOfFile: lrcFilePath, encoding: .unicode)
            model = KSCPaser(with: lrcContent).generateModel()
        }
        lyricsView.lyrics = model
        lyricsView.layer.borderColor = UIColor.black.cgColor
        lyricsView.layer.borderWidth = 1
        lyricsView.alignment = .center
        lyricsView.backgroundTextColor = UIColor.lightGray
        
        guard let musicPath = Bundle.main.url(forResource: "BeautifulLove.mp3" , withExtension: nil)  else { return }
        
        do {
            try player = AVAudioPlayer(contentsOf: musicPath)
        } catch {
            print("创建音频播放器失败:\(error)")
        }
        
        lyricsView.displayUpdated = { [weak self] lyricsView in
            lyricsView.time = self?.player?.currentTime ?? 0
        }
        
        player?.prepareToPlay()
        player?.play()
        
    }

}
