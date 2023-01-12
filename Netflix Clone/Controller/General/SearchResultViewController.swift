//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Rishi on 11/01/23.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func SearchResultViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    public var searchedMovie: [Movie] = [Movie]()

    public weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCellCollectionViewCell.self, forCellWithReuseIdentifier: MovieCellCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    
    
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellCollectionViewCell.identifier, for: indexPath) as? MovieCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = searchedMovie[indexPath.row]
        cell.configure(with: movie.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = self.searchedMovie[indexPath.row]
        guard let titleName = movie.title ?? movie.name else {return}
        
        APICaller.shared.getMovieTrailerWithQuery(with: titleName) { [weak self] results in
            switch results {
            case .success(let videoElement):
                self?.delegate?.SearchResultViewControllerDidTapItem(MoviePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: movie.overview ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
 
}
