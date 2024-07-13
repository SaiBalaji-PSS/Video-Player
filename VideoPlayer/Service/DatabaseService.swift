//
//  DatabaseService.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 13/07/24.
//

import Foundation
import UIKit
import CoreData

class DatabaseService{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var shared = DatabaseService()
    private init(){}
    
    
    func saveData(movieId: String,timeStamp: Double){
        var timeStampToBeSaved = MovieTS(context: context)
        timeStampToBeSaved.movieId = movieId
        timeStampToBeSaved.timeStamp = timeStamp
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
    func readAllTimeStamps(onCompletion:@escaping(Error?,[MovieTS]?)->(Void)){
        do{
            let timeStamps = try context.fetch(MovieTS.fetchRequest())
            onCompletion(nil,timeStamps)
        }
        catch{
            print(error)
            onCompletion(error,nil)
        }
    }
    func updateTimeStamp(movieTimeStamp: MovieTS,newTimeStamp: Double){
        movieTimeStamp.timeStamp = newTimeStamp
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
    
}
