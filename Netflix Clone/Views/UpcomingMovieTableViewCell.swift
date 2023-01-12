//
//  UpcomingMovieTableViewCell.swift
//  Netflix Clone
//
//  Created by Rishi on 11/01/23.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {

    static let identifier = "UpcomingMovieTableViewCell"
    
    private let playbutton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let moviePosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePosterUIImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(playbutton)
        
        applyConstratints()
    }
    
    
    private func applyConstratints() {
        let moviePosterUIImageViewConstraints = [
            moviePosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            moviePosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        let movieTitleLabelConstraints = [
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterUIImageView.trailingAnchor, constant: 20),
            movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            movieTitleLabel.widthAnchor.constraint(equalToConstant: 200)
        ]
        let playbuttonConstraints = [
            playbutton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playbutton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(moviePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(movieTitleLabelConstraints)
        NSLayoutConstraint.activate(playbuttonConstraints)
    }
    
    
    public func configure(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        moviePosterUIImageView.sd_setImage(with: url)
        movieTitleLabel.text = model.titleName
        
    }
    
    
    
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    
}
