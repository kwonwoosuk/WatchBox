//
//  MainViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/26/25.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    let profileImageName = UserDefaults.standard.string(forKey: "profileImageName")
    let userName = UserDefaults.standard.string(forKey: "UserName")
    private let joinedDate = UserDefaults.standard.object(forKey: "JoinDate") as? Date
    
    
    private let profileSection = ProfileSectionView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileSectionTapped))
        profileSection.addGestureRecognizer(tapGesture)
        profileSection.isUserInteractionEnabled = true
        
        navigationItem.title = "오늘의 영화"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    func updateProfileData() {
        let updatedUserName = UserDefaults.standard.string(forKey: "UserName")
        let updatedProfileImageName = UserDefaults.standard.string(forKey: "profileImageName")
        let updatedJoinedDate = UserDefaults.standard.object(forKey: "JoinDate") as? Date
//        print(updatedProfileImageName, updatedUserName, updatedJoinedDate)
        profileSection.configure(
            imageName: updatedProfileImageName ?? "profile_0",
            name: updatedUserName ?? "이름을 불러오지 못했습니다",
            joinedDate: updatedJoinedDate ?? Date()
            
        )
        
    }
    
    @objc
    private func profileSectionTapped() {
        let vc = ProfileSettingViewController()
        vc.isPresenting = true
        
        vc.nicknameTextField.text = userName
        vc.profileImageView.image = UIImage(named: "profileImageName")
        
        vc.profileUpdate = {
            self.updateProfileData()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    override func configureHierarchy() {
        [profileSection].forEach{ view.addSubview($0) }
    }
    
    override func configureLayout() {
        profileSection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
    }
    
    override func configureView() {
        profileSection.configure(imageName: profileImageName ?? "profile_0",
                                 name: userName ?? "이름을 불러오지 못했습니다",
                                 joinedDate: joinedDate ?? Date())
        
        
    }
}
