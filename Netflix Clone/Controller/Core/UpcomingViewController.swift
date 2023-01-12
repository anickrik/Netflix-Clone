//
//  UpcomingfViewController.swift
//  Netflix Clone
//
//  Created by Rishi on 10/01/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var upcomingMovies: [Movie] = [Movie ]()

    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(UpcomingMovieTableViewCell.self, forCellReuseIdentifier: UpcomingMovieTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let movie):
//                print(movie)
                self?.upcomingMovies = movie
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier, for: indexPath) as? UpcomingMovieTableViewCell else {
            return UITableViewCell()
        }
        let title = upcomingMovies[indexPath.row].name ?? upcomingMovies[indexPath.row].title ?? "Unknown"
        cell.configure(with: MovieViewModel(titleName: title, posterURL: upcomingMovies[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = upcomingMovies[indexPath.row]
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
