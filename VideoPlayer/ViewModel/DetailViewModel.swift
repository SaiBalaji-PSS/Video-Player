//
//  DetailViewModel.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 12/07/24.
//

import Foundation
import AVKit

class DetailViewModel{
     var player: AVPlayer?
     var playerLayer: AVPlayerLayer?
    var videoItems = [AVPlayerItem]()
    var currentIndex = 0
    
    func setupVideoPlayer(videoURLS:[String],playerView: UIView,controlView: UIView){
        //pass the selected video URL as first element in videoURLS array
        self.videoItems = videoURLS.map({ url  in
            AVPlayerItem(url: URL(string: url)!)
        })
        self.player = AVPlayer(playerItem: self.videoItems[0])
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer?.frame = playerView.bounds
        self.playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer{
            playerView.layer.addSublayer(playerLayer)
            playerView.layer.addSublayer(controlView.layer)
            self.player?.play()
        }
        
    }
    
    func playNextVideoInQueue(){
        if self.videoItems.isEmpty == false{
            self.currentIndex += 1
            self.player?.replaceCurrentItem(with: self.videoItems[self.currentIndex % self.videoItems.count])
            self.player?.seek(to: CMTime.zero, completionHandler: { _ in
                self.player?.play()
            })
        }
       
    }
    
    func playPreviousVideoInQueue(){
        if self.videoItems.isEmpty == false{
            self.currentIndex -= 1
            if self.currentIndex < 0{
                self.currentIndex = 0
            }
            self.player?.replaceCurrentItem(with: self.videoItems[self.currentIndex % self.videoItems.count])
            self.player?.seek(to: CMTime.zero, completionHandler: { _ in
                self.player?.play()
            })
        }
    }
    
    
    
}
