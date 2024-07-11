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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInBtnPressed(_ sender: GIDSignInButton) {
        print("Inside")
        guard let clientId = FirebaseApp.app()?.options.clientID else{return }
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self){ [unowned self] result, error in
            if let error{
                print(error)
            }
            if let user = result?.user{
                print(user.profile?.email)
                print(user.profile?.name)
                
            }
        }
    }
    
}

