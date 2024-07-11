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
    @Published var movies: [Movie]?
    
    func getAllMovies(){
        Task{
           let result = await NetworkService.shared.sendGETRequest(url: "https://interview-e18de.firebaseio.com/media.json?print=pretty", responseType: [Movie].self)
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let failure):
                self.error = error
            }
        }
    }
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
