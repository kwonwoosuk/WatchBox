//
//  MainViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/26/25.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {

    private let userName = UserDefaults.standard.string(forKey: "UserName")
    private let joinedDate = UserDefaults.standard.object(forKey: "JoinDate") as? Date
    private let ProfileImageName = UserDefaults.standard.string(forKey: "profileImageName")
    
    private let profileSection = ProfileSectionView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "오늘의 영화"
        
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
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
        profileSection.configure(imageName: ProfileImageName ?? "profile_0",
                                 name: userName ?? "이름을 불러오지 못했습니다",
                                 joinedDate: joinedDate ?? Date())
    }

}
