//
//  ProfileSectionView.swift
//  WatchBox
//
//  Created by 권우석 on 1/28/25.
//

import UIKit
import SnapKit

class ProfileSectionView: BaseView {
    private let backgroundView = UIView()
    
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let joinedDateLabel = UILabel()
    
    private let likeCountButton = UIButton()
    private let chevronButton = UIButton()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        [backgroundView,
         profileImageView,
         userNameLabel,
         joinedDateLabel,
         likeCountButton,
         chevronButton ].forEach{addSubview($0)}
    }
    
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(backgroundView).offset(16)
            make.top.equalTo(backgroundView).offset(16)
            make.size.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(26)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        joinedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(6)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        chevronButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(32)
            make.trailing.equalTo(backgroundView).offset(-16)
        }
        
        likeCountButton.snp.makeConstraints { make in
            
            make.horizontalEdges.equalTo(backgroundView).inset(16)
            make.bottom.equalTo(backgroundView).offset(-16)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        backgroundView.backgroundColor = .darkGray
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.accentBlue.cgColor
        profileImageView.layer.borderWidth = 3

        
        
        userNameLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        userNameLabel.textAlignment = .left
        userNameLabel.textColor = .white
        
        joinedDateLabel.font = .boldSystemFont(ofSize: 14)
        joinedDateLabel.textAlignment = .left
        joinedDateLabel.textColor = .gray
        
        
        chevronButton.tintColor = .gray
        chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        likeCountButton.setTitle("n개의 무비박스 보관중", for: .normal)
        likeCountButton.titleLabel?.textAlignment = .center
        likeCountButton.setTitleColor( .white, for: .normal)
        likeCountButton.backgroundColor = .accentBlue
        likeCountButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        likeCountButton.layer.cornerRadius = 12
        likeCountButton.clipsToBounds = true
        
        
        
    }
        
        
        
    
    func configure(imageName: String, name: String, joinedDate: Date) {
        profileImageView.image = UIImage(named: imageName)
        userNameLabel.text = name
        let joinedDate = joinedDate.signDateFormatting()
        joinedDateLabel.text = "\(joinedDate) 가입"
    }
        
    
}
