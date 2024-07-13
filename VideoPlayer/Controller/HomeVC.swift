//
//  HomeVC.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    private var vm = HomeViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    private var movies = [Movie]()
    private var sectionTitles = ["","Top Rated","Now Playing","Upcoming"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        self.setupBinding()
        vm.getAllMovies()
    }
    
    func configureUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logoutBtnPressed))
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Home"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "BannerCell", bundle: nil), forCellReuseIdentifier: "CELL")
        self.tableView.separatorStyle = .none
    }
    
    func setupBinding(){
        vm.$error.receive(on: RunLoop.main).sink { error  in
            if let error{
                print(error)
            }
        }.store(in: &cancellables)
        
        vm.$isSignOutSuccess.receive(on: RunLoop.main).sink { isSignOutSuccess in
            if let isSignOutSuccess{
                if isSignOutSuccess == true{
                    AppSession.shared.showSignInScreen()
                }
            }
                
        }.store(in: &cancellables)
        vm.$movies.receive(on: RunLoop.main).sink { movies  in
            if let movies{
                if movies.isEmpty == false{
                    print(movies)
                    self.movies = movies
                    self.tableView.reloadData()
                }
            }
        }.store(in: &cancellables)
    }

    @objc func logoutBtnPressed(){
        self.showMessage(title: "Info", message: "Do you want to log out?") {
            self.vm.signOutUser()
        }
        
    }
    
    func showMessage(title: String,message: String,onPress:@escaping()->(Void)){
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            onPress()
        }))
        avc.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(avc, animated: true)
    }
    
    
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? BannerCell{
                cell.delegate = self
                cell.tableViewIndex = indexPath
                cell.updateCell(movies: self.movies.shuffled())
                return cell
            }
        
        
       
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


extension HomeVC: BannerCellDelegate{
    func bannerCollectionViewCellClicked(movieData: Movie) {
        print(movieData)
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as? DetailVC{
            vc.selectedVideoURL = movieData.url
            //all the video urls with selected video url inserted at begining 
            var finalVideoURLs = self.movies.filter({ movie in
                return movie.url != movieData.url
            }).map({ movieData in
                return movieData.url
            })
            finalVideoURLs.insert(movieData.url, at: 0)
            vc.videoURLs = finalVideoURLs
            vc.selectedMovie = movieData
            vc.relatedMovies = self.movies
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
