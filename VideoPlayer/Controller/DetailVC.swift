//
//  DetailVC.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 12/07/24.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var playBackSlider: UISlider!
    @IBOutlet weak var backwardBtn: UIImageView!
    @IBOutlet weak var playPauseBtn: UIImageView!
    @IBOutlet weak var forwardBtn: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var previousImageView: UIImageView!
    
    @IBOutlet weak var endTimeLbl: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView!
    
    var videoURLs = [String]()
    var selectedVideoURL: String?
    private var vm = DetailViewModel()
    private var windowInterFace: UIInterfaceOrientation?{
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vm.setupVideoPlayer(videoURLS: videoURLs, playerView: self.playerView, controlView: self.controlView)
        self.configureUI()
    }
    
    
    func configureUI(){
        self.playerView.isUserInteractionEnabled = true
        self.playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerViewTapped)))
        self.nextImageView.isUserInteractionEnabled = true
        self.nextImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextImageViewTapped)))
        self.previousImageView.isUserInteractionEnabled = true 
        self.previousImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previousImageViewTapped)))
    }
    

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if windowInterFace?.isPortrait == true{
            self.heightConstraint.constant = 200
            self.navigationController?.navigationBar.isHidden = false
            self.bottomView.isHidden = false
        }
        else{
            self.heightConstraint.constant = self.view.layer.bounds.width
            self.bottomView.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
           // self.playerLayer?.frame = self.playerView.bounds
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vm.playerLayer?.frame = self.playerView.bounds
        }
    }
    
    @objc func nextImageViewTapped(){
        vm.playNextVideoInQueue()
    }
    @objc func previousImageViewTapped(){
        vm.playPreviousVideoInQueue()
    }
    @objc func playerViewTapped(){
        self.controlView.isHidden.toggle()
    }
    
}
