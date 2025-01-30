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
    
    
    let posterImageView = UIImageView()
    let movieTitle = UILabel()
    let movieOverview = UILabel()
    // 나중에 좋아요 버튼만 교체
    let likebutton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.layer.cornerRadius = 12
    }
    
    override func configureHierarchy() {
        [posterImageView,
         movieTitle,
         movieOverview,
         likebutton].forEach{ contentView.addSubview($0) }
    }
    
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(contentView.snp.width).multipliedBy(1.2)
            
        }
        
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(likebutton.snp.leading).offset(-8)
        }
        
        likebutton.snp.makeConstraints { make in
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
        
    }
    
    func configureData(data: Result) {
        let baseURL = "https://image.tmdb.org/t/p/original"
        if let posterURL = data.posterPath{
            let url = URL(string: baseURL + posterURL)
            posterImageView.kf.setImage(with: url)
        }
        movieTitle.text = data.title
        movieOverview.text = data.overview
    }
    
    
}
