//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Rishi on 10/01/23.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTvs = 1
    case PopularMovies = 2
    case PopolarTvs = 3
    case UpcomingMovies = 4
    case TopRatedMovies = 5
}


class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trending Movies","Trending Tv", "Popular Movies" ,"Popular Tvs", "Upcomming Movies","Top Rated",]
    
    private var randomTrendingMovie: Movie?
    private var headerView: HeroHeaderUIView?
    // create new tableView
    
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        // here we have registed our custom Cell
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // add table view as subview of main view
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        configureHeroHeaderView()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
//        Calling Apicaller to fetch movies
//        APICaller.shared.getTrandingMovies { results in
//            switch results {
//            case .success(let movie):
//                print(movie)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        APICaller.shared.getTrandingTvs { results in
//            switch results {
//            case .success(let tv):
//                print(tv)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        APICaller.shared.getUpcomingMovies { results in
//            switch results {
//            case .success(let movie):
//                print(movie)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        APICaller.shared.getTopRatedMovies { results in
//            switch results {
//            case .success(let movie):
//                print(movie)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        APICaller.shared.getPopularMovies { results in
//            switch results {
//            case .success(let movie):
//                print(movie)
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//        APICaller.shared.getPopularTvs { results in
//            switch results {
//            case .success(let tv):
//                print(tv)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        navigationController?.pushViewController(MoviePreviewViewController(), animated: true)
        // Do any additional setup after loading the view.
    }
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrandingMovies { result in
            switch result {
            case .success(let movie):
                let selectedMovie = movie.randomElement()
                let title = selectedMovie?.title ?? selectedMovie?.name ?? ""
                let postetPath = selectedMovie?.poster_path ?? ""
                self.randomTrendingMovie = selectedMovie
                self.headerView?.configure(with: MovieViewModel(titleName: title, posterURL: postetPath))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // configured Navigation bar as it button and logos
    private func configureNavbar() {
        
        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
//
//        let menuButton = UIButton(type: .custom)
//
//        menuButton.setBackgroundImage(image, for: .normal)
//        menuButton.addTarget(self, for: nil)
//        menuButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
//        view.bounds = view.bounds.offsetBy(dx: 10, dy: 2)
//        view.backgroundColor = .clear
//        view.addSubview(menuButton)
        
        let leftBarButton = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = leftBarButton
       
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.circle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
        header.textLabel?.frame = CGRect(x: Int(header.bounds.origin.x) + 20, y: Int(header.bounds.origin.y), width: 100, height: Int(header.bounds.height))
        header.textLabel?.textColor = .systemGray2
        
        //added extension for capiterlize first letter of title
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrandingMovies { results in
                        switch results {
                        case .success(let movie):
                            cell.configure(with: movie)
                        case .failure(let error):
                            print(error)
                        }
                    }
            
        case Sections.TrendingTvs.rawValue:
            APICaller.shared.getTrandingTvs { results in
                        switch results {
                        case .success(let movie):
                            cell.configure(with: movie)
                        case .failure(let error):
                            print(error)
                        }
                    }

        case Sections.PopularMovies.rawValue:
            APICaller.shared.getPopularMovies { results in
                        switch results {
                        case .success(let movie):
                            cell.configure(with: movie)
                        case .failure(let error):
                            print(error)
                        }
                    }
            
        case Sections.PopolarTvs.rawValue:
            APICaller.shared.getPopularTvs { results in
                        switch results {
                        case .success(let movie):
                            cell.configure(with: movie)
                        case .failure(let error):
                            print(error)
                        }
                    }
            
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { results in
                        switch results {
                        case .success(let movie):
                            cell.configure(with: movie)
                        case .failure(let error):
                            print(error)
                        }
                    }
             
        case Sections.TopRatedMovies.rawValue:
            APICaller.shared.getTopRatedMovies { results in
                        switch results {
                        case .success(let movie):
                            cell.configure(with: movie)
                        case .failure(let error):
                            print(error)
                        }
                    }
        default:
           return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    // this function let to hide/scroll up navigation bar when we scroll up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    
}


extension HomeViewController: CollectionTableViewCellDelegate {
    func CollectionTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
