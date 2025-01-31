//
//  ProfileViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import UIKit
import SnapKit

class SettingViewController: BaseViewController {
    
    
    
    let profileImageName = UserDefaults.standard.string(forKey: "profileImageName")
    let userName = UserDefaults.standard.string(forKey: "UserName")
    private let joinedDate = UserDefaults.standard.object(forKey: "JoinDate") as? Date
    
    
    private let profileSection = ProfileSectionView()
    
    private let menuTableView = UITableView()
    
    private let settingList: [String] = [
        "자주 묻는 질문",
        "1:1 문의",
        "알림 설정",
        "탈퇴하기"
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc
    private func profileSectionTapped() {
        let vc = ProfileSettingViewController()
        vc.isPresenting = true
        
        vc.nicknameTextField.text = userName
        
        if let imageName = profileImageName{
            vc.profileImageView.image = UIImage(named: imageName)
        }
        vc.profileUpdate = {
            self.updateProfileData()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    func updateProfileData() {
        let updatedUserName = UserDefaults.standard.string(forKey: "UserName")
        let updatedProfileImageName = UserDefaults.standard.string(forKey: "profileImageName")
        
        profileSection.configureUpdate(
            imageName: updatedProfileImageName ?? "profile_0",
            name: updatedUserName ?? "이름을 불러오지 못했습니다"
        )
    }
    
    override func configureHierarchy() {
        [profileSection, menuTableView].forEach{ view.addSubview($0) }
    }
    
    override func configureLayout() {
        profileSection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
        
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(profileSection.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        profileSection.configure(imageName: profileImageName ?? "profile_0",
                                 name: userName ?? "이름을 불러오지 못했습니다",
                                 joinedDate: joinedDate ?? Date())
        
        menuTableView.register(SettingViewTableViewCell.self, forCellReuseIdentifier: SettingViewTableViewCell.id)
        menuTableView.backgroundColor = .black
        menuTableView.separatorColor = .darkGray
        menuTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileSectionTapped))
        profileSection.addGestureRecognizer(tapGesture)
        profileSection.isUserInteractionEnabled = true
        
        navigationItem.title = "설정"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func configureDelegate() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }

}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return settingList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableViewCell.id , for: indexPath) as? SettingViewTableViewCell else { return UITableViewCell() }
        cell.settingMenuLabel.text = settingList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            showAlert(title: "탈퇴하기", message: "탈퇴하면 데이터가 모두 초기화 됩니다. 탈퇴하시겠습니까?", button: "확인") {
    

                UserDefaults.standard.removeObject(forKey: "isJoined")
                UserDefaults.standard.removeObject(forKey: "JoinDate")
                UserDefaults.standard.removeObject(forKey: "UserName")
                UserDefaults.standard.removeObject(forKey: "profileImageName")
                UserDefaults.standard.removeObject(forKey: "SearchHistory")
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else { return }
                window.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                window.makeKeyAndVisible()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true) // 손떼면 하이라이트 없애주는 메서드
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row != 3 {
                return nil
            }
            return indexPath
        }
    
    
}
