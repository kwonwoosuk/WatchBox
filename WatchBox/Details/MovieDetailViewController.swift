//
//  MovieDetailViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/30/25.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit
// 코드 전체적으로 탭했을떄 api요청이 있는경우는 여러번의 탭을 막고싶다 -추가해보기
final class MovieDetailViewController: BaseViewController {
    
    private let viewModel = MovieDetailViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    var movieId: Int?
    var releaseDate: String?
    var voteAverage: Double?
    var overview: String?
    var genreIDS: [Int]?
    let likeButton = UIButton()
    
    // MARK: - BackDrops
    private lazy var backDropsCV = UICollectionView(frame: .zero, collectionViewLayout: createBackdropsCollectionView())
//    private var backDrops: [Backdrop] = []
    private let pageControl = UIPageControl()
    
    // MARK: - synopsis -- more
    private let synopsisLabel = UILabel()
    private let overviews = UILabel()
    private let synopsisMoreButton = UIButton()
    
    // MARK: - infolabel
    private var infolabelView = InfoLabelView()
    
    // MARK: - Cast
    private let castLabel = UILabel()
    private lazy var castCV = UICollectionView(frame: .zero, collectionViewLayout: createCastCollectionView())
//    private var castList: [Cast] = []
    
    // MARK: - Poster
    private let posterLabel = UILabel()
//    private var posterList: [Posters] = []
    private lazy var posterCV = UICollectionView(frame: .zero, collectionViewLayout: createPosterCollectionView())
    
    private func createBackdropsCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth
        let cellHeight: CGFloat = 250
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        return layout
    }
    
    private func createCastCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 60)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .zero
        return layout
    }
    
    private func createPosterCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 156)
        layout.minimumLineSpacing = 8
        layout.sectionInset = .zero
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.input.viewDidLoad.value = movieId
    }
    
    private func bindData() {
        viewModel.output.backdrops.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.backDropsCV.reloadData()
            }
        }
        
        viewModel.output.posters.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.posterCV.reloadData()
            }
        }
        
        viewModel.output.casts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.castCV.reloadData()
            }
        }
        
        viewModel.output.pageCount.bind { [weak self] count in
            self?.pageControl.numberOfPages = count
        }
        
        //모양 옵데이트
        viewModel.output.isLiked.bind { [weak self] isLiked in
            let imageName = isLiked ? "heart.fill" : "heart"
            self?.likeButton.setImage(UIImage(systemName: imageName), for: .normal)
            self?.likeButton.tintColor = isLiked ? .accentBlue : .normalGray
        }
        
        viewModel.output.showError.bind { [weak self] error in
            if let error = error {
                self?.showAlert(title: error.title, message: error.message, button: "확인") {
                    self?.backDropsCV.reloadData()
                    self?.posterCV.reloadData()
                    self?.castCV.reloadData()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("UpdateLikeButton"), object: nil)
    }
    
    @objc
    private func likeButtonTapped() {
        viewModel.input.likeButtonTapped.value = movieId
    }
    
    @objc
    private func synopsisMoreButtonTapped() {
        synopsisMoreButton.isSelected.toggle()
        UIView.animate(withDuration: 0.3) {
            if self.synopsisMoreButton.isSelected {
                self.overviews.numberOfLines = 0
            } else {
                self.overviews.numberOfLines = 3
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backDropsCV,
         pageControl,
         infolabelView,
         synopsisLabel,
         overviews,
         synopsisMoreButton,
         castLabel,
         castCV,
         posterLabel,
         posterCV].forEach{ contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)  // 스크롤뷰와 같은 너비
            make.height.equalTo(scrollView)
        }
        
        backDropsCV.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            let deviceWidth = UIScreen.main.bounds.width
            make.width.equalTo(deviceWidth)
            make.height.equalTo(250)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backDropsCV.snp.bottom).offset(-16)
        }
        
        infolabelView.snp.makeConstraints { make in
            make.top.equalTo(backDropsCV.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(synopsisLabel.snp.top)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(infolabelView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(overviews.snp.top)
        }
        
        synopsisMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(synopsisLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(overviews.snp.top)
        }
        
        overviews.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(overviews.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        castCV.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(145)
        }
        
        posterLabel.snp.makeConstraints { make in
            make.top.equalTo(castCV.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(posterCV.snp.top)
        }
        
        posterCV.snp.makeConstraints { make in
            make.top.equalTo(posterLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(180)
        }
    }
    
    override func configureView() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .accentBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        likeButton.setImage(UIImage(named: "heart"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        scrollView.showsVerticalScrollIndicator = false
        
        backDropsCV.register(BackDropsCollectionViewCell.self, forCellWithReuseIdentifier: BackDropsCollectionViewCell.id)
        backDropsCV.isPagingEnabled = true
        backDropsCV.bounces = false
        backDropsCV.showsHorizontalScrollIndicator = false
        pageControl.currentPageIndicatorTintColor = .accentBlue
        pageControl.pageIndicatorTintColor = .normalGray
        pageControl.currentPage = 0
        pageControl.backgroundColor = .systemGray
        pageControl.layer.cornerRadius = 12
        pageControl.clipsToBounds = true
        
        infolabelView.configureInfoLabel(date: releaseDate, vote: voteAverage, genres: genreIDS)
        
        synopsisLabel.text = "Synopsis"
        synopsisLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        synopsisLabel.textAlignment = .left
        synopsisLabel.textColor = .white
        
        synopsisMoreButton.setTitle("More", for: .normal)
        synopsisMoreButton.setTitle("Hide", for: .selected)
        synopsisMoreButton.setTitleColor(.accentBlue, for: .normal)
        synopsisMoreButton.setTitleColor(.normalGray, for: .selected)
        synopsisMoreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        synopsisMoreButton.addTarget(self, action: #selector(synopsisMoreButtonTapped), for: .touchUpInside)
        configureSynopsis()
        
        overviews.font = .systemFont(ofSize: 14)
        overviews.textAlignment = .left
        overviews.textColor = .white
        
        castLabel.text = "Cast"
        castLabel.textColor = .white
        castLabel.textAlignment = .left
        castLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        
        castCV.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        castCV.showsHorizontalScrollIndicator = false
        castCV.backgroundColor = .clear
        
        posterLabel.text = "Poster"
        posterLabel.textColor = .white
        posterLabel.textAlignment = .left
        posterLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        
        posterCV.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
        posterCV.showsHorizontalScrollIndicator = false
        posterCV.backgroundColor = .clear
    }
    
    private func configureSynopsis() {
        if let overview {
            overviews.text = overview
            overviews.numberOfLines = 3
        }
    }
    
    override func configureDelegate() {
        backDropsCV.delegate = self
        backDropsCV.dataSource = self
        castCV.delegate = self
        castCV.dataSource = self
        posterCV.delegate = self
        posterCV.dataSource = self
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case backDropsCV:
            if viewModel.output.backdrops.value.count > 5 {
                return 5
            } else {
                return viewModel.output.backdrops.value.count
            }
        case castCV:
            return viewModel.output.casts.value.count
        default:
            return viewModel.output.posters.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case backDropsCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropsCollectionViewCell.id, for: indexPath) as? BackDropsCollectionViewCell,
                  let data = viewModel.getBackdrop(at: indexPath.item) else { return UICollectionViewCell() }
            cell.configureData(data: data)
            return cell
            
        case castCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as? CastCollectionViewCell,
                  let data = viewModel.getCast(at: indexPath.item) else { return UICollectionViewCell() }
            cell.configureData(data: data)
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as? PosterCollectionViewCell,
                  let data = viewModel.getPoster(at: indexPath.item) else { return UICollectionViewCell() }
            cell.configureData(data: data)
            return cell
        }    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == backDropsCV {
            let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            pageControl.currentPage = page
        }
    }
}
