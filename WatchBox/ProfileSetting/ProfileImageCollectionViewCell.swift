//
//  ProfileImageCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import UIKit
import SnapKit

class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "ProfileImageCollectionViewCell"
    private let profileImage = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(profileImage)
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(90)
        }
    }
    
    override func configureView() {
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 45
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1
        profileImage.alpha = 0.5
    }
    
    func configure(with imageName: String) {
        profileImage.image = UIImage(named: imageName)
    }
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            profileImage.alpha = 1.0
            profileImage.layer.borderColor = UIColor.accentBlue.cgColor
            profileImage.layer.borderWidth = 3
        } else {
            profileImage.alpha = 0.5
            profileImage.layer.borderColor = UIColor.normalGray.cgColor
            profileImage.layer.borderWidth = 1
        }
    }
}

