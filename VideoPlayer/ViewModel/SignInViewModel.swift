//
//  SignInViewModel.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import GoogleSignIn
import UIKit

class SignInViewModel: ObservableObject{
    @Published var authData: AuthDataResult?
    @Published var authError: Error?
    
    func intializeGoogleAuth(){
        guard let clientId = FirebaseApp.app()?.options.clientID else{return }
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
    }
    func signInBtnPressed(viewController: UIViewController){
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController){ [unowned self] result, error in
            if let error{
                print(error)
                self.authError = error
            }
            if let user = result?.user{
                if let id = user.idToken?.tokenString{
                    let credentials = GoogleAuthProvider.credential(withIDToken: id, accessToken: user.accessToken.tokenString)
                    Auth.auth().signIn(with: credentials){ result, error in
                        
                        // At this point, our user is signed in
                        if let error{
                            print(error)
                            self.authError = error
                        }
                        if let result{
                            print(result)
                            self.authData = result
                        }
                      }
                }
                
            }
        }
    }
}
