//
//  HomeViewModel.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import Foundation
import FirebaseAuth
import Combine

class HomeViewModel: ObservableObject{
    @Published var error: Error?
    @Published var isSignOutSuccess: Bool?
    
    func signOutUser(){
        do{
            try Auth.auth().signOut()
            self.isSignOutSuccess = true
        }
        catch{
            self.error = error
        }
       
    }
}
