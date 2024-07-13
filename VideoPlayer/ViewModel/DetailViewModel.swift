//
//  DetailViewModel.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 12/07/24.
//

import Foundation
import AVKit

class DetailViewModel: ObservableObject{
    private var seekValue = 15.0
     var player: AVPlayer?
     var playerLayer: AVPlayerLayer?
    var videoItems = [AVPlayerItem]()
    var currentIndex = 0
    @Published var currentTimeValue = ""
    @Published var endTimeValue = ""
    @Published var sliderValue: Float = 0.0
    
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
         //   self.player?.play()
            
           
                self.updateAudioPlayerUI()
            
        }
        
    }
    
    func updateAudioPlayerUI(){
        
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: 1), queue: DispatchQueue.global(qos: .userInteractive)) { time  in
            if self.player?.rate != 0{
                if let currentTime = self.player?.currentItem?.currentTime(), let endTime = self.player?.currentItem?.duration{
                    // DispatchQueue.main.async {
                    self.currentTimeValue = self.stringFromTimeInterval(interval: CMTimeGetSeconds(currentTime))
                    print("CURRENT TIME IS \(self.currentTimeValue)")
                    self.endTimeValue = "\(self.stringFromTimeInterval(interval: CMTimeGetSeconds(endTime)))"
                    //  self.playerSlider.value = Float((CMTimeGetSeconds(player.currentItem!.currentTime()) / CMTimeGetSeconds(playerItem.asset.duration)))
                    // }
                    self.sliderValue = Float((CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(endTime)))
                }
            }
            
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
    
    func seekForward(){
        if let currentTime = self.player?.currentTime(){
           let currentSeconds = CMTimeGetSeconds(currentTime)
           let newSeconds = currentSeconds + seekValue
            self.player?.seek(to: CMTimeMake(value: Int64(Int(newSeconds)), timescale: 1))
           
        }
    }
    
    func seekBackward(){
        if let currentTime = self.player?.currentTime(){
            let currentSeconds = CMTimeGetSeconds(currentTime)
            let newSeconds = currentSeconds - seekValue
            self.player?.seek(to: CMTime(value: Int64(Int(newSeconds)), timescale: 1))
        }
    }
    
    func playPause(){
        if self.player?.rate != 0.0{
            self.player?.pause()
        }
        else{
            self.player?.play()
        }
    }
    
    func getIsPlaying() -> Bool{
        return self.player?.rate != 0.0
    }
   
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        if interval.isNaN == false{
            let interval = Int(interval)
            let seconds = interval % 60
            let minutes = (interval / 60) % 60
            let hours = (interval / 3600)
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return ""
    }
    
    
    
}
