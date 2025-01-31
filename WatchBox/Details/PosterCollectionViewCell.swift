//
//  PosterCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 2/1/25.
//

import UIKit
import Kingfisher
import SnapKit

class PosterCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "PosterCollectionViewCell"
    
    var posterImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(posterImageView)
    }

    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(contentView)
        }
    }
    
    override func configureView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
    }
    
    func configureData(data: Posters) {
        let baseURL = "https://image.tmdb.org/t/p/original"
        
        if let posterURL = data.filePath {
            let url = URL(string: baseURL + posterURL)
            posterImageView.kf.setImage(with: url)
        }
    }
    
}
