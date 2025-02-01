//
//  CastCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 2/1/25.
//

import UIKit
import Kingfisher
import SnapKit

class CastCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "CastCollectionViewCell"
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let characterLabel = UILabel()
    
    override func configureHierarchy() {
        [profileImageView,
         nameLabel,
         characterLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            
            make.size.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        characterLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-4)
        }
        
    }
    
    
    override func configureView() {
        contentView.backgroundColor = .clear
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 25
        
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        
        
        characterLabel.textColor = .darkGray
        characterLabel.textAlignment = .left
        characterLabel.font = .systemFont(ofSize: 12)
        characterLabel.numberOfLines = 1
        
    }
    
    func configureData(data: Cast) {
        let baseURL = "https://image.tmdb.org/t/p/original"
        if let profileURL = data.profilePath {
            let url = URL(string: baseURL + profileURL)
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .normalGray
        }
        nameLabel.text = data.name
        nameLabel.lineBreakMode = .byTruncatingTail
        
        
        characterLabel.text = data.character
        characterLabel.lineBreakMode = .byTruncatingTail
    }
    
}
