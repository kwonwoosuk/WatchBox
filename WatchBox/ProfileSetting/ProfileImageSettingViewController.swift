//
//  ProfileImageSettingViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import UIKit
import SnapKit

// 선택한 이미지뷰 상단에 업데이트
// 선택한 이미지 보더컬러 지정, 알파값 조정
// 전부 회색보더로 -> 클릭한 버튼의 태그받아서 걔만 파랗게
// 선택한것 제외하고 색상 변경

class ProfileImageSettingViewController: BaseViewController {
    
    
    let profileImageView = UIImageView()
    var selectedImage: UIImage?
    private var profileButtons: [UIButton] = []
    
    private let images = [
        "profile_0", "profile_1", "profile_2", "profile_3", "profile_4",
        "profile_5", "profile_6", "profile_7", "profile_8", "profile_9",
        "profile_10", "profile_11"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = selectedImage
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 선택한 이미지 profilesettingview에 반영
    }
    
    
    override func configureHierarchy() {
        [ profileImageView
        ].forEach{ view.addSubview($0)}
        
        for i in 0..<12 {
            let button = UIButton()
            button.setImage(UIImage(named: images[i]), for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            button.layer.borderColor = UIColor.normalGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 40
            button.clipsToBounds = true
            button.tag = i
            button.alpha = 0.5
            button.addTarget(self, action: #selector(profileImageButtonTapped(_:)), for: .touchUpInside)
            profileButtons.append(button)
            view.addSubview(button)
        }
    }
    
    @objc
    private func profileImageButtonTapped(_ sender: UIButton) {
        profileButtons.forEach { button in
            button.alpha = 0.5
            button.layer.borderColor = UIColor.normalGray.cgColor
            button.layer.borderWidth = 1
        }
        sender.alpha = 1.0
        sender.layer.borderColor = UIColor.accentBlue.cgColor
        sender.layer.borderWidth = 3
        
        profileImageView.image = UIImage(named: images[sender.tag])
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.size.equalTo(100)
        }
        
        
        profileButtons[0].snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(35)
            make.size.equalTo(80)
        }
        
        profileButtons[1].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[0])
            make.left.equalTo(profileButtons[0].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
        profileButtons[2].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[0])
            make.left.equalTo(profileButtons[1].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
        profileButtons[3].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[0])
            make.left.equalTo(profileButtons[2].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
        // 두번째 줄 (4개)
        profileButtons[4].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[0].snp.bottom).offset(5)
            make.left.equalTo(profileButtons[0])
            make.size.equalTo(80)
        }
        
        profileButtons[5].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[4])
            make.left.equalTo(profileButtons[4].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
        profileButtons[6].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[4])
            make.left.equalTo(profileButtons[5].snp.right).offset(5)
            make.width.height.equalTo(profileButtons[0])
        }
        
        profileButtons[7].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[4])
            make.left.equalTo(profileButtons[6].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
        // 세번째 줄 (4개)
        profileButtons[8].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[4].snp.bottom).offset(5)
            make.left.equalTo(profileButtons[0])
            make.size.equalTo(80)
        }
        
        profileButtons[9].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[8])
            make.left.equalTo(profileButtons[8].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
        profileButtons[10].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[8])
            make.left.equalTo(profileButtons[9].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
        profileButtons[11].snp.makeConstraints { make in
            make.top.equalTo(profileButtons[8])
            make.left.equalTo(profileButtons[10].snp.right).offset(5)
            make.size.equalTo(80)
        }
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        
        
        
    }
    
    override func configureView() {
        navigationItem.title = "프로필 이미지 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .accentBlue
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.accentBlue.cgColor
        profileImageView.layer.borderWidth = 3
        
        
    }
    
    
    
}
