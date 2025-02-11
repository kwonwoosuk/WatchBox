//
//  BackDropsCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/31/25.
//

import UIKit
import Kingfisher
import SnapKit

final class BackDropsCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "BackDropsCollectionViewCell"
    
    private var backDropImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(backDropImageView)
    }

    override func configureLayout() {
        backDropImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(contentView)
        }
    }
    
    override func configureView() {
        backDropImageView.contentMode = .scaleAspectFill
        backDropImageView.clipsToBounds = true
    }
    
    func configureData(data: Backdrop) {
        
        if let backDropURL = TMDBRequest.getImageURL(path: data.filePath, size: TMDBRequest.ImageSize.w500) {
            backDropImageView.kf.setImage(with: backDropURL)
        }
    }

}
