//
//  PosterCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 2/1/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PosterCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "PosterCollectionViewCell"
    
    private var posterImageView = UIImageView()
    
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
        if let posterURL = TMDBRequest.getImageURL(path: data.filePath, size: TMDBRequest.ImageSize.poster) {
            posterImageView.kf.setImage(with: posterURL)
        }
    }
    
}
