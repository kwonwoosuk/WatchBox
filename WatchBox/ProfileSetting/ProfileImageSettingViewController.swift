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
    
    
    var selectedImageCell: ((String) -> Void)?
    let profileImageView = UIImageView()
    var isPresenting: Bool?
    var selectedImage: UIImage?
    private var selectedIndex: IndexPath?
    // 인덱스 패스가 들어올건데 안들어올 수도 있어 자동 Ni;l초기화
    // 역시 이렇게 생성하는건 뷰디드로드가 바로 안보여서 답답하다
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 6
        let width = (UIScreen.main.bounds.width - (spacing * 3)) / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
        return collectionView
    }()

    private let images = [
        "profile_0", "profile_1", "profile_2", "profile_3", "profile_4",
        "profile_5", "profile_6", "profile_7", "profile_8", "profile_9",
        "profile_10", "profile_11"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = selectedImage // 전 화면에서 랜덤선택되엇던 것
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectedIndex { // shorthand 사용해봅니다
            selectedImageCell?(images[selectedIndex.item])
        } // 선택한 이미지 profilesettingview에 반영
       
    }

    override func configureHierarchy() {
        [ profileImageView, collectionView
        ].forEach{ view.addSubview($0)}
    }

    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.size.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    override func configureView() {
        navigationItem.title = isPresenting == true ? "프로필 이미지 편집" : "프로필 이미지 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .accentBlue
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.accentBlue.cgColor
        profileImageView.layer.borderWidth = 3
    }
}

extension ProfileImageSettingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.configure(with: images[indexPath.item])

        if indexPath == selectedIndex { //안들어 있을경우 모두 false
            cell.setSelected(true)
        } else {
            cell.setSelected(false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        profileImageView.image = UIImage(named: images[indexPath.item])
        collectionView.reloadData()
    }
}
