//
//  DataManager.swift
//  Netflix Clone
//
//  Created by Rishi on 12/01/23.
//

import Foundation
import UIKit
import CoreData

class LocalDataManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = LocalDataManager()
    
    func saveToWatchList(with model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let movieItem = MovieItem(context: context)
        
        movieItem.title = model.title
        movieItem.name = model.name
        movieItem.id = Int64(model.id)
        movieItem.poster_path = model.poster_path
        movieItem.overview = model.overview
        movieItem.originalTitle = model.originalTitle
        movieItem.original_name = model.original_name
        movieItem.originalLanguage = model.originalLanguage
        movieItem.original_language = model.original_language
        movieItem.popularity = model.popularity
        movieItem.releaseDate = model.releaseDate
        movieItem.vote_count = Int64(model.vote_count)
        movieItem.vote_average = model.vote_average ?? 0.0

        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    
    func fetchMoviesFromDatabase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    
    func removeMovieFromWatchList(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}


