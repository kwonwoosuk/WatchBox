//
//  ProfileSettingViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/26/25.
//

import UIKit
import SnapKit


final class ProfileSettingViewController: BaseViewController {
    
    
    // 이미지뷰 클릭시 프로필 이미지설정화면으로 넘어가려면 유저 인터렉션 허용, 탭 제스쳐 추가.. 버튼으로 만드는방법도 있음
    let profileImageView = UIImageView()
    private let cameraIcon = UIImageView()
    private let nicknameTextField = UITextField()
    private let textFieldUnderLine = UIView()
    private let nicknameStatusConfirmLabel = UILabel()
    private let saveButton = UIButton()
    
    private let profileImageCount = 11
    var isSigned = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isSigned = false
        UserDefaults.standard.set(isSigned, forKey: "isSigned") //  탈퇴 할때도 사용
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        randomProfileImage()
        updateLabel(isValid: false, message: "")
        
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc
    private func profileImageViewTapped() {
        let profileSettingImageVC = ProfileImageSettingViewController()
        profileSettingImageVC.selectedImage = profileImageView.image // 자연스럽기 위함입니다...
        
        profileSettingImageVC.selectedImageCell = { imageName in
            self.profileImageView.image = UIImage(named: imageName)
        }
        
        navigationController?.pushViewController(profileSettingImageVC, animated: true)
    }
    
    @objc
    func saveButtonTapped() {
        UserDefaults.standard.set(nicknameTextField.text, forKey: "UserName")
        isSigned = true
        UserDefaults.standard.set(isSigned, forKey: "isSigned")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = UINavigationController(rootViewController: TabBarController())
        window.makeKeyAndVisible()
        
        // 이름이랑 이미지 설정한거 넘겨줘야함
    }
    
    private func randomProfileImage() {
        let randomNumber = Int.random(in: 0...profileImageCount)
        let image = "profile_\(randomNumber)"
        profileImageView.image = UIImage(named: image)
    }
    
    override func configureHierarchy() {
        [ profileImageView,
          cameraIcon,
          nicknameTextField,
          textFieldUnderLine,
          nicknameStatusConfirmLabel,
          saveButton
        ].forEach{ view.addSubview($0)}
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.size.equalTo(100)
        }
        
        cameraIcon.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.size.equalTo(35)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(1)
        }
        
        nicknameStatusConfirmLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderLine.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusConfirmLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        cameraIcon.layer.cornerRadius = cameraIcon.frame.width / 2
        cameraIcon.clipsToBounds = true
    }
    
    override func configureView() {
        
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .accentBlue
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.accentBlue.cgColor
        profileImageView.layer.borderWidth = 3
    
        textFieldUnderLine.backgroundColor = .white
        
        cameraIcon.image = UIImage(systemName: "camera.fill")
        cameraIcon.contentMode = .center
        cameraIcon.tintColor = .white
        cameraIcon.backgroundColor = .accentBlue
        
        nicknameTextField.placeholder = "닉네임을 입력하세요..."
        nicknameTextField.setColor(.lightGray)
        nicknameTextField.textColor = .white
        
        nicknameStatusConfirmLabel.text = ""
        nicknameStatusConfirmLabel.textColor = .accentBlue
        nicknameStatusConfirmLabel.font = .systemFont(ofSize: 14)
        
        saveButton.setTitle("완료", for: .normal)
        saveButton.setTitleColor(.accentBlue , for: .normal)
        saveButton.setTitleColor(.white, for: .highlighted)
        saveButton.backgroundColor = .clear
        saveButton.layer.borderColor = UIColor.accentBlue.cgColor
        saveButton.layer.borderWidth = 3
        saveButton.layer.cornerRadius = 24
        saveButton.clipsToBounds = true
    }
    
    
    //textFieldDidChangeSelection는 선택영역이 변결될때: 커서위치, 드래그한 단어같은 것이 바뀔때
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
            updateLabel(isValid: false, message: "공백은 사용할 수 없어요")
            return
        }
        if text.count < 2 || text.count >= 10 {
            updateLabel(isValid: false, message: "2글자 이상 10글자 미만으로 설정해주세요")
            return
        }
        // 1. rangeOfCharacter 특정 chararcterSet에 포함되는지! 특수문자가 포함되지 않으면 Nil을 반환한다
        // 2. 정규식을 사용하는 방법
        // 3. bool값을 반환하는 방법도 찾아보니 있긴하다 ... text에서는 사용해보지 않은 메서드 unicodeScalars?
        if text.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) != nil {
            updateLabel(isValid: false, message: "닉네임에 @,#,$,% 는 포함할 수 없어요")
            return
        }
        
        let containNumber = text.contains { $0.isNumber }
        if containNumber {
            updateLabel(isValid: false, message: "닉네임에 숫자는 포함할 수 없어요")
            return
        }
        updateLabel(isValid: true, message: "사용할 수 있는 닉네임이에요")
    }
    
    private func updateLabel(isValid: Bool, message: String) {
        saveButton.isEnabled = isValid
        saveButton.layer.borderColor = isValid ? UIColor.accentBlue.cgColor : UIColor.normalGray.cgColor
        saveButton.setTitleColor(.accentBlue, for: .normal)
        saveButton.setTitleColor(.normalGray, for: .disabled)
        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
        
        nicknameStatusConfirmLabel.text = message
        nicknameStatusConfirmLabel.textColor = isValid ? .accentBlue : .red
    }
    
    
}
/*
 button.isEnabled = true
 button.backgroundColor = .blue
 
 
 button.isEnabled = false
 button.backgroundColor = .gray
 
 
 button.alpha = button.isEnabled ? 1.0 : 0.5
 */
