//
//  InfoLabelView.swift
//  WatchBox
//
//  Created by 권우석 on 2/1/25.
//

import UIKit
import SnapKit
class InfoLabelView: BaseView {
    
    private let backgroundView = UIView()
    private let calenderImageView = UIImageView()
    private let releasedateLabel = UILabel()
    
    private let starImageView = UIImageView()
    private let voteAverageLabel = UILabel()
    
    private let genreImageView = UIImageView()
    private let genresLabel = UILabel()
    
    override func configureHierarchy() {
        [backgroundView,
         calenderImageView,
         releasedateLabel,
         starImageView,
         voteAverageLabel,
         genreImageView,
         genresLabel,].forEach{ addSubview($0) }
    }
    
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        calenderImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(8)
            make.trailing.equalTo(releasedateLabel.snp.leading).offset(-4)
        }
        
        releasedateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calenderImageView)
            make.trailing.equalTo(starImageView.snp.leading).offset(-4)
        }
        
        starImageView.snp.makeConstraints { make in
            make.centerY.equalTo(calenderImageView)
            make.centerX.equalToSuperview()
        }
        
        voteAverageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calenderImageView)
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
        }
        
        genreImageView.snp.makeConstraints { make in
            make.centerY.equalTo(calenderImageView)
            make.leading.equalTo(voteAverageLabel.snp.trailing).offset(4)
        }
        
        genresLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calenderImageView)
            make.leading.equalTo(genreImageView.snp.trailing).offset(4)
        }
    }
    
    override func configureView() {
        backgroundView.backgroundColor = .clear
        
        calenderImageView.image = UIImage(systemName: "calendar")
        calenderImageView.tintColor = .gray
        calenderImageView.contentMode = .center
        
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.contentMode = .center
        starImageView.tintColor = .gray
        
        genreImageView.image = UIImage(systemName: "film.fill")
        genreImageView.contentMode = .center
        genreImageView.tintColor = .gray
        
        releasedateLabel.font = .systemFont(ofSize: 14)
        releasedateLabel.textAlignment = .center
        releasedateLabel.textColor = .gray

        voteAverageLabel.font = .systemFont(ofSize: 14)
        voteAverageLabel.textAlignment = .center
        voteAverageLabel.textColor = .gray
        
        genresLabel.font = .systemFont(ofSize: 14)
        genresLabel.textAlignment = .center
        genresLabel.textColor = .gray
    }
    
    func configureInfoLabel(date: String?, vote: Double?, genres: [Int]?) {
        if let date {
            releasedateLabel.text = "\(date)  | "
        }
        
        if let vote {
            voteAverageLabel.text = "\(String(format: "%.1f", vote))  | "
        }
        
        if let genres {
            var genre = ""
            
            for (index, i) in genres.enumerated() {
                if index >= 2 { break }
                
                if let genreName = GenreType.genres[i] {
                    if index == 0 {
                        genre = genreName
                    } else {
                        genre += ", " + genreName
                    }
                }
            }
            genresLabel.text = " \(genre)"
        }
    }
}
