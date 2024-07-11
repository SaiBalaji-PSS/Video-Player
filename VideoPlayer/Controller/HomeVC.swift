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
    
    private var cancellables = Set<AnyCancellable>()
    
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
        avc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            onPress()
        }))
        avc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(avc, animated: true)
    }
    
    
}
