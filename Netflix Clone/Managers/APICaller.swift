//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Rishi on 10/01/23.
//

import Foundation


struct Constants {
    static let apiKey = "b40aecce2fa831c0c3f6c7f2f42f4a5d"
    static let baseURL = "https://api.themoviedb.org"
    static let trandingEndPoint = "/3"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3"
    static let youyubeApiKey = "AIzaSyA_l9cdi6dDfAzgzcLA33cr4-03I_mrudA"
    
    // url == https://api.themoviedb.org/3/trending/all/day?api_key=b40aecce2fa831c0c3f6c7f2f42f4a5d
}

enum APIError: Error {
    case failedToGetData
}


class APICaller {
    static let shared = APICaller()
    
    
    func getTrandingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/trending/movie/week?api_key=\(Constants.apiKey)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getTrandingTvs(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/trending/tv/week?api_key=\(Constants.apiKey)") else { return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
//                print(error.localizedDescription)
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/movie/upcoming?api_key=\(Constants.apiKey)") else { return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
                print("Error while fetching upcoming movies")
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/movie/top_rated?api_key=\(Constants.apiKey)") else { return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/movie/popular?api_key=\(Constants.apiKey)") else { return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getPopularTvs(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/tv/popular?api_key=\(Constants.apiKey)") else { return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getDiscoverMovie(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/discover/movie?api_key=\(Constants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func searchMovieWithQuery(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        // below used to formate query before parsing to actual URL
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.trandingEndPoint)/search/movie?api_key=\(Constants.apiKey)&query=\(query)&page=1") else { return }
//        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResultData.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getMovieTrailerWithQuery(with query: String, completion: @escaping (Result<Item, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.youtubeBaseURL)/search?q=\(query)&key=\(Constants.youyubeApiKey)") else {
            return
        }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
//                let result = try JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed)
//                print(result)
                let result = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            } catch {
//                print(error.localizedDescription)
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    
        
        
        
    }
    
    
    
}

//top rated
// https://api.themoviedb.org/3/movie/top_rated?api_key=b40aecce2fa831c0c3f6c7f2f42f4a5d
//https://api.themoviedb.org/3/movie/upcoming?api_key=b40aecce2fa831c0c3f6c7f2f42f4a5d
//use below to print response as String to console
//JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed)
