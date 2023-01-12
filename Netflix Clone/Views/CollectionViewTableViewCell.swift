//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Rishi on 10/01/23.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func CollectionTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    private var movies: [Movie] = [Movie]()
    
    weak var delegate: CollectionTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCellCollectionViewCell.self , forCellWithReuseIdentifier: MovieCellCollectionViewCell.identifier )
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemMint
        
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    public func configure(with movies: [Movie]){
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadMovieAt(at indexPath: IndexPath) {
        LocalDataManager.shared.saveToWatchList(with: movies[indexPath.row]) { result in
            switch result {
            case .success():
                print("Added to WatchList")
                
                //firig notification to listen to changes in watch list view controller
                NotificationCenter.default.post(name: NSNotification.Name("addedToWatchList"), object: nil)
            case.failure(let error):
                print(error)
            }
        }
//        print(movies[indexPath.row].name ?? movies[indexPath.row].title)
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellCollectionViewCell.identifier, for: indexPath) as? MovieCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movies[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        guard let movieTitle = movie.title ?? movie.name else {
            return
        }
        APICaller.shared.getMovieTrailerWithQuery(with: movieTitle + "trailer") { results in
            switch results {
            case.success(let videoElement):
                self.delegate?.CollectionTableViewCellDidTapCell(self, viewModel: MoviePreviewViewModel(title: movieTitle, youtubeView: videoElement, titleOverview: movie.overview ?? ""))
            case .failure(let error):
                print("Error While getting Trailer from YouTube \(error.localizedDescription)")
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath] , point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Add to watchlist",state: .off) { _ in
                    self?.downloadMovieAt(at: indexPaths[0])
                }
                downloadAction.image = UIImage(systemName: "restart")
                return UIMenu(options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
    
    
    
}
