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

class MovieDetailViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    var movieId: Int?
    var releaseDate: String?
    var voteAverage: Double?
    var overview: String?
    var genreIDS: [Int]?
    let likebutton = UIButton()
    
    // MARK: - BackDrops
    lazy var backDropsCV = UICollectionView(frame: .zero, collectionViewLayout: createBackdropsCollectionView())
    var backDrops: [Backdrop] = []
    
    // MARK: - synopsis -- more
    private let synopsisLabel = UILabel()
    private let overviews = UILabel()
    private let synopsisMoreButton = UIButton()
    
    // MARK: - infolabel
    var infolabelView = InfoLabelView()
    
    // MARK: - Cast
    private let castLabel = UILabel()
    lazy var castCV = UICollectionView(frame: .zero, collectionViewLayout: createCastCollectionView())
    var castList: [Cast] = []
    
    // MARK: - Poster
    private let posterLabel = UILabel()
    var posterList: [Posters] = []
    lazy var posterCV = UICollectionView(frame: .zero, collectionViewLayout: createPosterCollectionView())
    
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
        callRequest(movieId: movieId)
    }
    
    func callRequest(movieId: Int?) {
       guard let id = movieId else { return }
       
       let group = DispatchGroup()
       
       group.enter()
       NetworkManager.shared.callRequest(api: .image(movieId: id), type: Images.self) { response in
           self.backDrops = response.backdrops
           self.posterList = response.posters
           group.leave()
           
       } failHandler: {
           self.showAlert(title: "정보를 불러오지 못했습니다", message: "다시 요청하시겠습니까?", button: "확인") {
               self.backDropsCV.reloadData()
               self.posterCV.reloadData()
           }
           group.leave()
       }
       
       group.enter()
       NetworkManager.shared.callRequest(api: .credit(movieId: id), type: Credit.self) { response in
           self.castList = response.cast
           group.leave()
           
       } failHandler: {
           self.showAlert(title: "정보를 불러오지 못했습니다", message: "다시 요청하시겠습니까?", button: "확인") {
               self.castCV.reloadData()
           }
           group.leave()
       }
       
       group.notify(queue: .main) {
           self.backDropsCV.reloadData()
           self.posterCV.reloadData()
           self.castCV.reloadData()
       }
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backDropsCV,
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
        
        scrollView.showsVerticalScrollIndicator = false
        
        backDropsCV.register(BackDropsCollectionViewCell.self, forCellWithReuseIdentifier: BackDropsCollectionViewCell.id)
        backDropsCV.isPagingEnabled = true
        backDropsCV.bounces = false
        backDropsCV.showsHorizontalScrollIndicator = false
        
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
    
    @objc
    func synopsisMoreButtonTapped() {
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
    
    func configureSynopsis() {
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
            if backDrops.count > 5 {
                return 5
            } else {
                return backDrops.count
            }
        case castCV:
            return castList.count
        default:
            return posterList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case backDropsCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropsCollectionViewCell.id, for: indexPath) as? BackDropsCollectionViewCell else { return UICollectionViewCell()}
            let data = backDrops[indexPath.item]
            cell.configureData(data: data)
            return cell
            
        case castCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell()}
            let data = castList[indexPath.item]
            cell.configureData(data: data)
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as? PosterCollectionViewCell else { return
                UICollectionViewCell() }
            let data = posterList[indexPath.item]
            cell.configureData(data: data)
            return cell
        }
    }
}
