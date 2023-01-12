//
//  WatchListViewController.swift
//  Netflix Clone
//
//  Created by Rishi on 10/01/23.
//

import UIKit

class WatchListViewController: UIViewController {

    private var watchListMovies: [MovieItem] = [MovieItem ]()

    private let watchListTable: UITableView = {
        let table = UITableView()
        table.register(UpcomingMovieTableViewCell.self, forCellReuseIdentifier: UpcomingMovieTableViewCell.identifier)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Watch List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(watchListTable)
        watchListTable.delegate = self
        watchListTable.dataSource = self
        fetchMoviesFromLocalStorage()
        
        //here we listen to the notification coming from HomeViewController
        NotificationCenter.default.addObserver(forName: NSNotification.Name("addedToWatchList"), object: nil, queue: nil) { _ in
            self.fetchMoviesFromLocalStorage()
        }
    }
    
    private func fetchMoviesFromLocalStorage() {
        LocalDataManager.shared.fetchMoviesFromDatabase { [weak self] result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.watchListMovies = movie
                    self?.watchListTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        watchListTable.frame = view.bounds
    }

}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchListMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier, for: indexPath) as? UpcomingMovieTableViewCell else {
            return UITableViewCell()
        }
        let title = watchListMovies[indexPath.row].name ?? watchListMovies[indexPath.row].title ?? "Unknown"
        cell.configure(with: MovieViewModel(titleName: title, posterURL: watchListMovies[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            LocalDataManager.shared.removeMovieFromWatchList(model: watchListMovies[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Removed From Watchlist")
                    self.watchListMovies.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print("Failed to Remove \(error.localizedDescription)")
                }
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = watchListMovies[indexPath.row]
        guard let titleName = movie.title ?? movie.name else {return}
        APICaller.shared.getMovieTrailerWithQuery(with: titleName) { [weak self] results in
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = MoviePreviewViewController()
                    vc.configure(with: MoviePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: movie.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
