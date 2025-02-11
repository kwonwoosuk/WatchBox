//
//  MainViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/26/25.
//

import UIKit
import SnapKit
// fourthWeek
// photoproject // topic
class TodayMovieViewController: BaseViewController {
    
    private let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.profileImageName.rawValue)
    private let userName = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName.rawValue)
    private let joinedDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.joinDate.rawValue) as? Date
    
    private let profileSection = ProfileSectionView()
    
    private let recentSearchKeywordLabel = UILabel()
    private let allClearButton = UIButton()
    private let emptyLabel = UILabel()
    private let todayMovieLabel = UILabel()
    
    private var searchHistory: [String] = UserDefaults.standard.stringArray(forKey: "SearchHistory") ?? []
    private var todayMovieList: [TrendingResult] = []
    
    private lazy var searchHistoryCV = UICollectionView(frame: .zero, collectionViewLayout: createSearchHistoryCollectionView())
    private lazy var todayMovieCV = UICollectionView(frame: .zero, collectionViewLayout: createTodayMovieCollectionView())
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileData()
        updateSearchHistory()
        callRequset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSearchHistory()
        profileSection.updateLikeCount()
    }
    
    func callRequset() {
        NetworkManager.shared.callRequest(api: .trending, type: Trending.self) { result in
            switch result {
            case .success(let response):
                self.todayMovieList = response.results
                self.todayMovieCV.reloadData()
            case .failure:
                self.showAlert(title: "네트워크 통신에러", message: "정보를 불러오지 못했습니다", button: "확인") {
                    self.todayMovieCV.reloadData()
                }
            }
        }
    }
    
    @objc
    private func profileSectionTapped() {
        let vc = ProfileSettingViewController()
        vc.isPresenting = true
        
        vc.nicknameTextField.text = userName
        
        if let imageName = profileImageName {
            vc.profileImageView.image = UIImage(named: imageName)
        }
        vc.profileUpdate = {
            self.updateProfileData()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
    
    func updateProfileData() {
        let updatedUserName = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName.rawValue)
        let updatedProfileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.profileImageName.rawValue)
        
        profileSection.configureUpdate(
            imageName: updatedProfileImageName ?? "profile_0",
            name: updatedUserName ?? "이름을 불러오지 못했습니다"
        )
    }
    
    private func createSearchHistoryCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return layout
    }
    
    private func createTodayMovieCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth * 2/3
        let cellHeight = cellWidth * 1.5
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return layout
    }
    
    override func configureHierarchy() {
        [profileSection,
         recentSearchKeywordLabel,
         allClearButton,
         emptyLabel,
         searchHistoryCV,
         todayMovieLabel,
         todayMovieCV].forEach{ view.addSubview($0) }
    }
    
    override func configureLayout() {
        profileSection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
        //최근 검색어 (제목)
        recentSearchKeywordLabel.snp.makeConstraints { make in
            make.top.equalTo(profileSection.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        // 전체삭제
        allClearButton.snp.makeConstraints { make in
            make.top.equalTo(profileSection.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        //최근 검색어 내역이 없습니다.
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchKeywordLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        // 최근 검색어 내역
        searchHistoryCV.snp.makeConstraints { make in
            make.top.equalTo(recentSearchKeywordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        // 오늘의 영화 (제목)
        todayMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryCV.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        // 오늘의 영화 셀
        todayMovieCV.snp.makeConstraints { make in
            make.top.equalTo(todayMovieLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
    }
    
    override func configureView() {
        updateProfileData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileSectionTapped))
        profileSection.addGestureRecognizer(tapGesture)
        profileSection.isUserInteractionEnabled = true
        
        navigationItem.title = "WatchBox"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let rightBarSearchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightBarSearchButtonTapped))
        rightBarSearchButton.tintColor = .accentBlue
        navigationItem.rightBarButtonItem = rightBarSearchButton
        
        recentSearchKeywordLabel.text = "최근검색어"
        recentSearchKeywordLabel.textColor = .white
        recentSearchKeywordLabel.textAlignment = .left
        recentSearchKeywordLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        
        allClearButton.setTitle("전체삭제", for: .normal)
        allClearButton.setTitleColor(.accentBlue, for: .normal)
        allClearButton.setTitleColor(.normalGray, for: .highlighted)
        allClearButton.titleLabel?.font = .systemFont(ofSize: 14)
        allClearButton.addTarget(self, action: #selector(allClearButtonTapped), for: .touchUpInside)
        
        emptyLabel.text = "최근 검색어 내역이 없습니다."
        emptyLabel.textColor = .darkGray
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        
        todayMovieLabel.text = "오늘의 영화"
        todayMovieLabel.textColor = .white
        todayMovieLabel.textAlignment = .left
        todayMovieLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        
        profileSection.configure(imageName: profileImageName ?? "profile_0",
                                 name: userName ?? "이름을 불러오지 못했습니다",
                                 joinedDate: joinedDate ?? Date())
    }
    
    private func updateSearchHistory() {
        searchHistory = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.searchHistory.rawValue) ?? []
        emptyLabel.isHidden = !searchHistory.isEmpty
        searchHistoryCV.isHidden = searchHistory.isEmpty
        searchHistoryCV.reloadData()
    }
    
    @objc
    private func allClearButtonTapped() {
        searchHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.searchHistory.rawValue)
        updateSearchHistory()
    }
    
    override func configureDelegate() {
        searchHistoryCV.delegate = self
        searchHistoryCV.dataSource = self
        searchHistoryCV.backgroundColor = .clear
        searchHistoryCV.register(SearchKeywordCollectionViewCell.self, forCellWithReuseIdentifier: SearchKeywordCollectionViewCell.id)
        
        todayMovieCV.delegate = self
        todayMovieCV.dataSource = self
        todayMovieCV.backgroundColor = .clear
        todayMovieCV.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.id)
    }
    
    @objc
    func rightBarSearchButtonTapped() {
        let vc = SearchResultViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension TodayMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.searchHistoryCV:
            return searchHistory.count
        default:
            return todayMovieList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.searchHistoryCV:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchKeywordCollectionViewCell.id, for: indexPath) as? SearchKeywordCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureKeyword(searchQuery: searchHistory[indexPath.item])
            
            cell.deleteButtonHandler = {
                self.searchHistory.remove(at: indexPath.item)
                UserDefaults.standard.set(self.searchHistory, forKey: UserDefaultsKeys.searchHistory.rawValue)
                self.updateSearchHistory()
            }
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            let data = todayMovieList[indexPath.item]
            cell.configureData(data: data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case searchHistoryCV:
            let vc = SearchResultViewController()
            let selectedKeyword = searchHistory[indexPath.item]
            vc.movieSearchBar.text = selectedKeyword
            
            vc.callRequest(query: selectedKeyword)
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            let vc = MovieDetailViewController()
            vc.navigationItem.title = todayMovieList[indexPath.item].title
            vc.movieId = todayMovieList[indexPath.item].id
            vc.releaseDate = todayMovieList[indexPath.item].releaseDate
            vc.voteAverage = todayMovieList[indexPath.item].voteAverage
            vc.overview = todayMovieList[indexPath.item].overview
            vc.genreIDS = todayMovieList[indexPath.item].genreIDS
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

