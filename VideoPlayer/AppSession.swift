//
//  AppSession.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import Foundation
import UIKit
import FirebaseAuth

class AppSession{
    private init(){}
    static var shared = AppSession()
    private var window: UIWindow!
    
    func start(window: UIWindow){
        self.window = window
        if Auth.auth().currentUser == nil{
            self.showSignInScreen()
        }
        else{
            self.showHomeScreen()
        }
    }
    
    
    func showSignInScreen(){
        if window != nil{
            if let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC{
                window.rootViewController = signInVC
                
            }
        }
       
    }
    func showHomeScreen(){
        if window != nil{
            if let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC{
                window.rootViewController = UINavigationController(rootViewController: homeVC)
            }
           
        }
    }
}
