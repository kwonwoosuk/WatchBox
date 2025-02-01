//
//  TodayMovieCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/29/25.
//

import UIKit
import SnapKit
import Kingfisher
//photoproject // topic
class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    
    
    static let id = "TodayMovieCollectionViewCell"
    
    
    private let posterImageView = UIImageView()
    private let movieTitle = UILabel()
    private let movieOverview = UILabel()
    // 나중에 좋아요 버튼만 교체
    private var movieId: Int?
    private let likeButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.layer.cornerRadius = 12
    }
    
    override func configureHierarchy() {
        [posterImageView,
         movieTitle,
         movieOverview,
         likeButton].forEach{ contentView.addSubview($0) }
    }
    
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(contentView.snp.width).multipliedBy(1.2)
            
        }
        
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(likeButton.snp.leading).offset(-8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(movieTitle)
            make.trailing.equalToSuperview().inset(8)
            make.size.equalTo(44)
        }
        
        movieOverview.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func configureView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        movieTitle.font = .systemFont(ofSize: 16, weight: .heavy)
        movieTitle.textColor = .white
        movieTitle.textAlignment = .left
        
        movieOverview.font = .systemFont(ofSize: 14)
        movieOverview.numberOfLines = 2
        movieOverview.textColor = .white
        movieOverview.textAlignment = .left
        
        likeButton.setImage(UIImage(named: "heart"), for: .normal)
        likeButton.tintColor = .normalGray
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
    }
    
    @objc
    private func likeButtonTapped() {
        guard let movieId = movieId else { return }
        var likedMovies = UserDefaults.standard.array(forKey: "LikedMovies") as? [Int] ?? []
        
        if likedMovies.contains(movieId) {
            likedMovies.removeAll { $0 == movieId }
        } else {
            likedMovies.append(movieId)
        }
        
        UserDefaults.standard.set(likedMovies, forKey: "LikedMovies")
        updateLikeButtonImage()
        NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: nil)
    }
    
    private func updateLikeButtonImage() {
        guard let movieId = movieId else { return }
        let likedMovies = UserDefaults.standard.array(forKey: "LikedMovies") as? [Int] ?? []
        let imageName = likedMovies.contains(movieId) ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = likedMovies.contains(movieId) ? .accentBlue : .normalGray
    }
    
    func configureData(data: Result) {
        
        movieId = data.id
        let baseURL = "https://image.tmdb.org/t/p/original"
        if let posterURL = data.posterPath{
            let url = URL(string: baseURL + posterURL)
            posterImageView.kf.setImage(with: url)
        }
        movieTitle.text = data.title
        movieOverview.text = data.overview
        
        updateLikeButtonImage()
    }
    
    
}
