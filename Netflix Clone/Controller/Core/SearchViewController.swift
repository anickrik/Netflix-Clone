//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Rishi on 10/01/23.
//

import UIKit

class SearchViewController: UIViewController {

    private var searchMovies: [Movie] = [Movie]()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(UpcomingMovieTableViewCell.self, forCellReuseIdentifier: UpcomingMovieTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search a Moview or TV Show"
        controller.searchBar.searchBarStyle = .minimal

        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchTable)
        searchTable.delegate = self
        searchTable.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        fetchSearchedMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    private func fetchSearchedMovies() {
        APICaller.shared.getDiscoverMovie { [weak self] results in
            switch results {
            case .success(let movie):
//                print(movie)
                self?.searchMovies = movie
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier, for: indexPath) as? UpcomingMovieTableViewCell else {
            return UITableViewCell()
        }
        let title = searchMovies[indexPath.row].name ?? searchMovies[indexPath.row].title ?? "Unknown"
        cell.configure(with: MovieViewModel(titleName: title, posterURL: searchMovies[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = searchMovies[indexPath.row]
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


extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        resultsController.delegate = self
        APICaller.shared.searchMovieWithQuery(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let movie):
                    resultsController.searchedMovie = movie
                    resultsController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print("Error while Searching \(error.localizedDescription)")
                }
            }
        }
    }
    
    func SearchResultViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async  { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
