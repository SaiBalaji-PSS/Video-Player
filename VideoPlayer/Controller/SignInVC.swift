//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import Combine

class SignInVC: UIViewController {
    private var vm = SignInViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vm.intializeGoogleAuth()
        self.setupBinding()
    }
    
    @IBAction func signInBtnPressed(_ sender: GIDSignInButton) {
        print("Inside")
        vm.signInBtnPressed(viewController: self)
        
    }
    func setupBinding(){
        vm.$authData.receive(on: RunLoop.main).sink { authData in
            if let authData{
                print(authData)
                AppSession.shared.showHomeScreen()
            }
        }.store(in: &cancellables)
        vm.$authError.receive(on: RunLoop.main).sink { authError in
            if let authError{
                print(authError)
            }
        }.store(in: &cancellables)
    }
}

