//
//  BackDropsCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/31/25.
//

import UIKit
import SnapKit

class BackDropsCollectionViewCell: BaseCollectionViewCell {
    
    var backDropImageView = UIImageView()
    
    
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
    }
    
    
}
