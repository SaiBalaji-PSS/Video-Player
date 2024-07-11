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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? BannerCell{
            cell.updateCell(movies: self.movies)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
