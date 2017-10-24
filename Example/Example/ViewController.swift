//
//  ViewController.swift
//  Example
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit
import LyricsView
import AVFoundation

class ViewController: UIViewController {

    private let label = LyricsLabel()
    
    private let lyricsView = LyricsView()
    private var player: AVAudioPlayer?
    private var updateLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        var line = KSCLineModel()
        line.characters = ["beautiful ", "love"]
//        line.characters = ["中", "文"]
        line.intervals = [1, 1]
        label.line = line
        label.currentTime = 1.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sangTextColor = UIColor.blue
        label.backgroundTextColor = UIColor.lightGray
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1

        view.addSubview(label)
        NSLayoutConstraint(item: label,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1,
                           constant: 30).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 375).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 100).isActive = true
        /*
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
                  */
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
                           constant: 80).isActive = true

        let fileName = "BeautifulLove.ksc"
        guard let lrcFilePath = Bundle.main.path(forResource: fileName, ofType: nil)  else { return }
        let lrcContent = try! String(contentsOfFile: lrcFilePath, encoding: .unicode)
        let model = KSCPaser(with: lrcContent).generateModel()
        lyricsView.lyrics = model
        lyricsView.layer.borderColor = UIColor.black.cgColor
        lyricsView.layer.borderWidth = 1
        lyricsView.alignment = .top
        guard let musicPath = Bundle.main.url(forResource: "BeautifulLove.mp3" , withExtension: nil)  else { return }

        do {
            try player = AVAudioPlayer(contentsOf: musicPath)
        } catch {
            print("创建音频播放器失败:\(error)")
        }

        updateLink = CADisplayLink(target: self, selector: #selector(update))
        updateLink?.isPaused = true
        updateLink?.add(to: RunLoop.current, forMode: .commonModes)
        updateLink?.isPaused = false
        player?.prepareToPlay()
        player?.currentTime = 20
        player?.play()

    }
    
    @objc func update() {
        lyricsView.time = player?.currentTime ?? 0
//        print(lyricsView.time)
    }

    @objc func startAnimation() {
        label.animate(intervals:[0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 1, 0.5, ])
    }
}

