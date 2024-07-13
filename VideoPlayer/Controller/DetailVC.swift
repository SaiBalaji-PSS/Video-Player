//
//  DetailVC.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 12/07/24.
//

import UIKit
import AVKit
import Combine

class DetailVC: UIViewController {

    @IBOutlet weak var backBtnImageView: UIImageView!
  //  @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var playBackSlider: UISlider!
    @IBOutlet weak var backwardBtn: UIImageView!
    @IBOutlet weak var playPauseBtn: UIImageView!
    @IBOutlet weak var forwardBtn: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var previousImageView: UIImageView!
    
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var endTimeLbl: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var movieNameLbl: UILabel!
    
    @IBOutlet weak var movieDescriptionLbl: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var videoURLs = [String]()
    var selectedVideoURL: String?
    var selectedMovie: Movie?
    var relatedMovies = [Movie]()
    
    private var vm = DetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var windowInterFace: UIInterfaceOrientation?{
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    private var filteredMovie: MovieTS?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupTouchGesture()
        self.setupBiding()
        self.configureUI()
        self.navigationController?.navigationBar.isHidden = true
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.playerView.layer.addSublayer(self.thumbNailImageView.layer)
        vm.setupVideoPlayer(videoURLS: videoURLs, playerView: self.playerView, controlView: self.controlView)
        DatabaseService.shared.readAllTimeStamps { error , timeStamps in
            if let error{
                print(error)
            }
            if let timeStamps{
                print(timeStamps)
               if let filteredMovie = timeStamps.filter { movie in
                    movie.movieId == self.selectedMovie?.id
               }.first{
                   print(filteredMovie)
                   self.filteredMovie = filteredMovie
                   self.vm.resumePlayingFromTimeStamp(seconds: filteredMovie.timeStamp)
                 //  self.controlView.isHidden = true
                   self.playPauseBtn.image = UIImage(systemName: "pause")
               }
               
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupTouchGesture(){
        self.playerView.isUserInteractionEnabled = true
        self.playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerViewTapped)))
        self.nextImageView.isUserInteractionEnabled = true
        self.nextImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextImageViewTapped)))
        self.previousImageView.isUserInteractionEnabled = true
        self.previousImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previousImageViewTapped)))
        self.forwardBtn.isUserInteractionEnabled = true
        self.forwardBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seekForwardTapped)))
        self.backwardBtn.isUserInteractionEnabled = true
        self.backwardBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seekBackwardTapped)))
        self.playPauseBtn.isUserInteractionEnabled = true
        self.playPauseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playPauseTapped)))
        self.backBtnImageView.isUserInteractionEnabled = true
        self.backBtnImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnTapped)))
        self.fullScreenImageView.isUserInteractionEnabled = true
        self.fullScreenImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fullScreenBtnTapped)))
        
    }
    
    func configureUI(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CELL")
        if let selectedMovie{
           // self.thumbNailImageView.contentMode = .scaleAspectFill
           // self.thumbNailImageView.sd_setImage(with: URL(string: selectedMovie.thumb))
            self.movieNameLbl.text = selectedMovie.title
            self.movieDescriptionLbl.text = selectedMovie.description
            self.posterImageView.contentMode = .scaleAspectFill
            self.posterImageView.sd_setImage(with: URL(string: selectedMovie.thumb ?? ""))
            
        }
    }
    
    func setupBiding(){
        vm.$currentTimeValue.receive(on: RunLoop.main).removeDuplicates().sink { currentValue in
            self.startTimeLbl.text = currentValue
       
        }.store(in: &cancellables)
        vm.$endTimeValue.receive(on: RunLoop.main).sink { endValue in
            self.endTimeLbl.text = endValue
        }.store(in: &cancellables)
        vm.$sliderValue.receive(on: RunLoop.main).sink { sliderValue in
            self.playBackSlider.value = sliderValue
        }.store(in: &cancellables)
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
          //  self.collectionView.reloadData()
           // self.playerLayer?.frame = self.playerView.bounds
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vm.playerLayer?.frame = self.playerView.bounds
            self.collectionView.reloadData()
        }
    }
    
    @objc func nextImageViewTapped(){
        vm.playNextVideoInQueue()
        self.playPauseBtn.image = UIImage(systemName: "pause")
    }
    @objc func previousImageViewTapped(){
        vm.playPreviousVideoInQueue()
        self.playPauseBtn.image = UIImage(systemName: "pause")
    }
    @objc func playerViewTapped(){
        self.controlView.isHidden.toggle()
    }
    @objc func seekForwardTapped(){
        vm.seekForward()
        
    }
    @objc func seekBackwardTapped(){
        vm.seekBackward()
    }
    @objc func playPauseTapped(){
       // self.thumbNailImageView.isHidden = true
        if vm.getIsPlaying(){
            self.playPauseBtn.image = UIImage(systemName: "play")
            self.controlView.isHidden = false
        }
        else{
            self.playPauseBtn.image = UIImage(systemName: "pause")
            self.controlView.isHidden = true
           
        }
        vm.playPause()
      
    }
    @objc func backBtnTapped(){
       
            
            if let currentDuration = vm.player?.currentItem?.currentTime(){
                print(currentDuration)
                let interval = Int(CMTimeGetSeconds(currentDuration))
                let seconds = interval % 60
                print(seconds)
                print(CMTimeMakeWithSeconds(CMTimeGetSeconds(currentDuration), preferredTimescale: 600))
                
                if let filteredMovie{
                    //data is already in db so update
                    DatabaseService.shared.updateTimeStamp(movieTimeStamp: filteredMovie, newTimeStamp: Double(seconds))
                }
                else{
                    //data is not in db so create
                    DatabaseService.shared.saveData(movieId: self.selectedMovie?.id ?? "", timeStamp: Double(seconds))
                }
               
            }
  
        
      
        self.vm.player?.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func fullScreenBtnTapped(){
        if #available(iOS 16.0, *){
            guard let windowScreen = self.view.window?.windowScene else{return }
            //go to fullscreen
            if windowScreen.interfaceOrientation == .portrait{
                windowScreen.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)){error in
                    print(error)
                }
                self.fullScreenImageView.image = UIImage(systemName: "arrow.up.right.and.arrow.down.left")
            }
            //return from full screen
            else if windowScreen.interfaceOrientation == .landscapeLeft || windowScreen.interfaceOrientation == .landscapeRight{
                windowScreen.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)){error in
                    print(error)
                }
               
                self.fullScreenImageView.image = UIImage(systemName: "arrow.down.left.and.arrow.up.right")
            }
        }
        else{
            //go to fullscreen
            if UIDevice.current.orientation == .portrait{
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft, forKey: "orientation")
                
                self.fullScreenImageView.image = UIImage(systemName: "arrow.up.right.and.arrow.down.left")
            }
            //return from full screen
            else if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight{
                UIDevice.current.setValue(UIInterfaceOrientation.portrait, forKey: "orientation")
                
                self.fullScreenImageView.image = UIImage(systemName: "arrow.down.left.and.arrow.up.right")
            }
        }
    }
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.relatedMovies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as? BannerCollectionViewCell{
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.white.cgColor
            cell.updateCell(url: self.relatedMovies[indexPath.item].thumb ?? "")
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension UIViewController {
    class func setUIInterfaceOrientation(_ value: UIInterfaceOrientation) {
        UIDevice.current.setValue(value.rawValue, forKey: "orientation")
    }
}
