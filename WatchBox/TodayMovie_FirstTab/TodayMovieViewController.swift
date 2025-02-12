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
final class TodayMovieViewController: BaseViewController {
    
    private let viewModel = TodayMovieViewModel()
    
    private let profileSection = ProfileSectionView()
    private let recentSearchKeywordLabel = UILabel()
    private let allClearButton = UIButton()
    private let emptyLabel = UILabel()
    private let todayMovieLabel = UILabel()
    
    private lazy var searchHistoryCV = UICollectionView(frame: .zero, collectionViewLayout: createSearchHistoryCollectionView())
    private lazy var todayMovieCV = UICollectionView(frame: .zero, collectionViewLayout: createTodayMovieCollectionView())
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.value = ()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        profileSection.updateLikeCount()
        searchHistoryCV.reloadData()
    }
    
    private func bindData() {
        viewModel.output.profile.bind { [weak self] profile in
            if let profile {
                self?.profileSection.configure(
                    imageName: profile.imageName,
                    name: profile.name,
                    joinedDate: profile.date
                )
            }
        }
        
        viewModel.output.searchedHistory.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchHistoryCV.reloadData()
            }
        }
        
        // 검색 기록 유무에 따른 UI 업데이트
        viewModel.output.isEmptySearchHistory.bind { [weak self] isEmpty in
            self?.emptyLabel.isHidden = !isEmpty
            self?.searchHistoryCV.isHidden = isEmpty
        }
        
        viewModel.output.todayMovies.bind { [weak self] _ in
            self?.todayMovieCV.reloadData()
        }
        
        viewModel.output.showError.bind { [weak self] error in
            if let error = error {
                self?.showAlert(title: error.title, message: error.message, button: "확인") {
                    self?.todayMovieCV.reloadData()
                }
            }
        }
    }
    
    @objc
    private func allClearButtonTapped() {
        viewModel.input.allClearTapped.value = ()
    }
    
    @objc
    private func profileSectionTapped() {
        let vc = ProfileSettingViewController()
        vc.isPresenting = true
        
        if let profile = viewModel.output.profile.value {
            vc.nicknameTextField.text = profile.name
            vc.profileImageView.image = UIImage(named: profile.imageName)
        }
        
        vc.profileUpdate = { [weak self] in
            self?.viewModel.input.viewWillAppear.value = ()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
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
            return viewModel.output.searchedHistory.value.count
        default:
            return viewModel.output.todayMovies.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.searchHistoryCV:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchKeywordCollectionViewCell.id, for: indexPath) as? SearchKeywordCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureKeyword(searchQuery: viewModel.output.searchedHistory.value[indexPath.item])//값이 없오?
            
            cell.deleteButtonHandler = { [weak self] in
                self?.viewModel.input.deleteKeyword.value = indexPath.item
            }
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            if let movie = viewModel.getSelectedMovie(at: indexPath.item) {
                cell.configureData(data: movie)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case searchHistoryCV:
            let vc = SearchResultViewController()
            
            if let keyword = viewModel.getSelectedKeyword(at: indexPath.item) {
                vc.movieSearchBar.text = keyword
                vc.callRequest(query: keyword)
            }
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            
            if let movie = viewModel.getSelectedMovie(at: indexPath.item) {
                let vc = MovieDetailViewController()
                vc.navigationItem.title = movie.title
                vc.movieId = movie.id
                vc.releaseDate = movie.releaseDate
                vc.voteAverage = movie.voteAverage
                vc.overview = movie.overview
                vc.genreIDS = movie.genreIDS
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

