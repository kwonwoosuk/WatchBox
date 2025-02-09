//
//  SearchResultTableViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/30/25.
//

import UIKit
import SnapKit
import Kingfisher
final class SearchResultTableViewCell: BaseTableViewCell {
    
    static let id = "SearchResultTableViewCell"
    
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let releaseDateLabel = UILabel()
    var genreArray: [UILabel] = []
    var movieId: Int?
    let likeButton = UIButton()
    
    
    override func configureHierarchy() {
        [thumbnailImageView,
         titleLabel,
         releaseDateLabel,
         likeButton].forEach{ contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            make.height.equalTo(18)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            make.height.equalTo(12)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        for i in 0...1 { // 두개까지...
            let label = createGenreLabel()
            label.snp.makeConstraints { make in
                make.bottom.equalTo(contentView.snp.bottom).offset(-16)
                if i == 0 {
                    make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
                } else {
                    make.leading.equalTo(genreArray[0].snp.trailing).offset(4)
                }
                make.height.equalTo(20)
                make.width.equalTo(60)
            }
            genreArray.append(label)
        }
        
    }
    //나중에 많이보여주고 스크롤되도록 시킬수도 있으니...
    private func createGenreLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        contentView.addSubview(label)
        return label
    }
    
    override func configureView() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.clipsToBounds = true
        //영화제목 2줄까지 
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        
        releaseDateLabel.font = .boldSystemFont(ofSize: 13)
        releaseDateLabel.textColor = .darkGray
        releaseDateLabel.textAlignment = .left
    
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

    @objc
    private func updateLikeButtonImage() {
        guard let movieId = movieId else { return }
        let likedMovies = UserDefaults.standard.array(forKey: "LikedMovies") as? [Int] ?? []
        let imageName = likedMovies.contains(movieId) ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = likedMovies.contains(movieId) ? .accentBlue : .normalGray
    }
    
    func configureData(data: SearchResult) {
        movieId = data.id
        titleLabel.text = data.title
        if let date = data.releaseDate {
            let releaseDate = String.formatDate(date: date)
            
            releaseDateLabel.text = releaseDate
        }
        
        let baseURL = "https://image.tmdb.org/t/p/original"
        
        if let posterURL = data.posterPath {
            let url = URL(string: baseURL + posterURL)
            thumbnailImageView.kf.setImage(with: url)
        }
        
        genreArray.forEach { $0.isHidden = true }
        let genreIDs = Array(data.genreIDS.prefix(2)) // 앞에서 부터 두개 가져오기
        
        for (index, genreID) in genreIDs.enumerated() {
            if let genreName = GenreType.genres[genreID] {
                let label = genreArray[index]
                label.text = "\(genreName)"
                label.isHidden = false
            }
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLikeButtonImage),
                                                 name: NSNotification.Name("UpdateLikeButton"),
                                                 object: nil)
        updateLikeButtonImage()
    }
    
    
}
