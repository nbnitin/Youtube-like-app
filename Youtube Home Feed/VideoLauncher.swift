//
//  VideoLauncher.swift
//  Youtube Home Feed
//
//  Created by Nitin on 17/01/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView : UIView {
    
    var player : AVPlayer?
    var isPlaying : Bool = false
    var videoFullyEnds = false
    var parentView : UIView!
    var playerLayer : AVPlayerLayer!
    var isMinimised = false
    
    let activityIndicatorView :  UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView()
        aiView.style = .whiteLarge
        aiView.translatesAutoresizingMaskIntoConstraints = false
        aiView.startAnimating()
        aiView.hidesWhenStopped = true
        return aiView
    }()
    
    let lblVideoLength : UILabel = {
       let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let lblVideoCurrentTime : UILabel = {
       let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let btnMinimise : UIButton = {
        let btn = UIButton()
        btn.setTitle("<", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
        btn.addTarget(self, action: #selector(minimiseView), for: .touchUpInside)
        return btn
    }()
    
    let btnClose : UIButton = {
        let btn = UIButton()
        btn.setTitle("X", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        return btn
    }()
    
    let videoSlider : UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(named:"red thumb"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    
    let btnPausePlay : UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named:"pause")
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        btn.tintColor = .white
        btn.isHidden = true
        return btn
    }()
    
    let controlContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerView()
        
        setupGradientLayer()
        
        controlContainerView.frame = frame
        addSubview(controlContainerView)
        addSubview(activityIndicatorView)
        addSubview(btnPausePlay)
        addSubview(btnMinimise)
        addSubview(btnClose)

        
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       
        btnPausePlay.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        btnPausePlay.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        btnPausePlay.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnPausePlay.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        btnMinimise.topAnchor.constraint(equalTo: topAnchor,constant: 8).isActive = true
        btnMinimise.leftAnchor.constraint(equalTo: leftAnchor,constant: 8).isActive = true
        btnMinimise.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnMinimise.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        btnClose.topAnchor.constraint(equalTo: topAnchor,constant: 8).isActive = true
        btnClose.rightAnchor.constraint(equalTo: rightAnchor,constant: 8).isActive = true
        btnClose.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        controlContainerView.addSubview(lblVideoLength)
        lblVideoLength.bottomAnchor.constraint(equalTo: controlContainerView.bottomAnchor,constant: -2).isActive = true
        lblVideoLength.rightAnchor.constraint(equalTo: controlContainerView.rightAnchor,constant:-8).isActive = true
        lblVideoLength.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lblVideoLength.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlContainerView.addSubview(lblVideoCurrentTime)
        lblVideoCurrentTime.bottomAnchor.constraint(equalTo: controlContainerView.bottomAnchor,constant: -2).isActive = true
        lblVideoCurrentTime.leftAnchor.constraint(equalTo: controlContainerView.leftAnchor,constant:8).isActive = true
        lblVideoCurrentTime.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lblVideoCurrentTime.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlContainerView.addSubview(videoSlider)
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.rightAnchor.constraint(equalTo: lblVideoLength.leftAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: lblVideoCurrentTime.rightAnchor,constant: 4).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        backgroundColor = .black
    }
    
    @objc func closeVideo(){
        player?.pause()
        playerLayer.removeFromSuperlayer()
        parentView.removeFromSuperview()
        UIApplication.shared.setStatusBarHidden(false, with: .slide)

        
    }
    
    @objc func minimiseView(){
        print("123")
        if let keyWindow = UIApplication.shared.keyWindow {
            if ( isMinimised ) {
                
                    parentView.frame = parentView.frame
                    parentView.backgroundColor = .white
                    //16 x 9 is the aspect ration of all HD Videos
                    let height = keyWindow.frame.width * 9 / 16
                    
                 
                    self.frame.size.width = keyWindow.frame.width
                    self.frame.size.height = height

                 
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        self.showLowerPart()
                        self.parentView.frame = keyWindow.frame
                    }, completion: {(completionHandler) in
                        UIApplication.shared.setStatusBarHidden(true, with: .slide)
                     self.isMinimised = false
                        self.btnMinimise.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)

                    })
            } else {
                    parentView.frame = keyWindow.frame
                    parentView.backgroundColor = .white
                    self.frame.size.width = 200
                    self.frame.size.height = 200

                
                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.parentView.frame = CGRect(x: keyWindow.frame.width - self.frame.size.width - 30, y: keyWindow.frame.height - self.frame.size.height - 30,width:self.playerLayer.frame.width, height: self.playerLayer.frame.height)
                    self.hideLowerPart()
                       //self.parentView.frame = keyWindow.frame
                   }, completion: {(completionHandler) in
                       UIApplication.shared.setStatusBarHidden(false, with: .slide)
                    self.isMinimised = true
                    self.btnMinimise.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)

                   })
               
            }
        }
        
    }
    
    private func hideLowerPart() {
        self.lblVideoLength.isHidden = true
        self.lblVideoCurrentTime.isHidden = true
        self.videoSlider.isHidden = true
    }
    
    private func showLowerPart() {
        self.lblVideoLength.isHidden = false
        self.lblVideoCurrentTime.isHidden = false
        self.videoSlider.isHidden = false
    }
    
    
    @objc func handlePause() {
        if ( player?.timeControlStatus == .playing ) {
            player?.pause()
            isPlaying = false
            let image = UIImage(named:"play")
            btnPausePlay.setImage(image, for: .normal)
        } else {
            if ( videoFullyEnds ) {
                let value = 0.0
                let seekTime = CMTime(value: Int64(value), timescale: 1)
                player?.seek(to: seekTime, completionHandler: {(completionHandler) in
                })
                videoFullyEnds = false
            }
            player?.play()
            let image = UIImage(named:"pause")
            btnPausePlay.setImage(image, for: .normal)
            isPlaying = true
        }
    }
    
    @objc func handleSliderChange() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: {(completionHandler) in
            })
        }
    }
    
    private func setupGradientLayer() {
        let gradeintLayer = CAGradientLayer()
        gradeintLayer.frame = bounds
        gradeintLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradeintLayer.locations = [0.7,1.2]
        controlContainerView.layer.addSublayer(gradeintLayer)
    }

    
   private func setupPlayerView() {
        let url = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        if let urlString = URL(string: url) {
            player = AVPlayer(url: urlString)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.frame
            self.layer.addSublayer(playerLayer)
            player?.play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval:interval  , queue: DispatchQueue.main, using: {(progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format:"%02d",Int(seconds) % 60)
                let minutesString = String(format:"%02d",Int(seconds) / 60)
                self.lblVideoCurrentTime.text = "\(minutesString):\(secondsString)"
                
                //slider defualts goes to 0 to 1 only
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                    
                    if ( progressTime == duration ) {
                        self.isPlaying = false
                        self.handlePause()
                        self.videoFullyEnds = true
                    }
                }
                
                
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = .clear
            btnPausePlay.isHidden = false
            isPlaying = true
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format:"%02d",Int(seconds) / 60)
                lblVideoLength.text = "\(minutesText):\(secondsText)"
            }
            print(change)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoLauncher : NSObject {
    let view : UIView = UIView()

    func showVideoPlayer(){
        print("show video")
        if let keyWindow = UIApplication.shared.keyWindow {
            view.frame = keyWindow.frame
            view.backgroundColor = .white
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10,width:100, height: 100)
            //16 x 9 is the aspect ration of all HD Videos
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerView = VideoPlayerView(frame: CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height))
            view.addSubview(videoPlayerView)
            keyWindow.addSubview(view)
            videoPlayerView.parentView = view
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.frame = keyWindow.frame
            }, completion: {(completionHandler) in
                UIApplication.shared.setStatusBarHidden(true, with: .slide)
            })
        }
    }
}
