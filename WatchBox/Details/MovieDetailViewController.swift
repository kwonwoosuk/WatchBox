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
/*
 백드롭 영역
 1번째 컬렉션 뷰 백드롭 이미지 최대 5장
 백드롭 하단에 개봉일, 별점 , 장르 이전뷰에서 끌고오기
 레이블에 이미지를 넣어야하는데
 , 역사 이거 그냥 infolabel이라치고 한번에 넣으면 안되나?
 그냥 이미지뷰 따로따로 하면 되잖아...
 uipagecontrlo
 페이징 기능 있음
 수평스크롤
 
 
 시놉시스영역
 overview끌고 와야함
 화면 진입시 최대 3줄까지 보여줌 Numberofline = 3
 more버튼 클릭시 전부 다 보여줌 Numberofline = 0
 레이아웃도 맞춰서 밀어줘야할듯 어짜피 스크롤 되니까 괜찮다
 
 캐스트영역
 creditAPI로 불러오기
 영화 케스트 전체를 보여주고 수평스크롤
 프로필 이미지 뷰 profilePath
 이름 name
 영어일수도 있는 이름 character
 
 포스터영역
 전체를 보여주고 수평스크롤
 */

class MovieDetailViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
    var movieId: Int?
    var releaseDate: String?
    var voteAverage: Double?
    var overview: String?
    var genreIDS: [Int]?
   
    
    // MARK: - synopsis -- more
    private let synopsisLabel = UILabel()
    private let synopsisMoreButton = UIButton()
    
    
    // MARK: - infolabel
    var infolabelView = InfoLabelView()
    
    // MARK: - cast
    private let castLabel = UILabel()
    
    // MARK: - poster
    private let posterLabel = UILabel()
                        
    lazy var backDropsCV = UICollectionView(frame: .zero, collectionViewLayout: createBackdropsCollectionView())
    
    
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
    
    
    
    
    var backDrops: [Backdrop] = []
    var casts: [Cast] = []
    var posters: [Posters] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequestBackdrop(movieId: movieId)
        // 위치에 맞게 넣어주기만 하고 백드롭만 통신하면 될 것같다
//        print(movieId, releaseDate, voteAverage, overview, genreIDS)
        
    }
    //이걸로 poster구현후 poster까지 하면 될 것 같다 
    func callRequestBackdrop(movieId: Int?) {
        if let id = movieId {
            NetworkManager.shared.callRequest(api: .image(movieId: id), type: Images.self) { response in
                self.backDrops = response.backdrops
                self.backDropsCV.reloadData()
                print(response.backdrops)
            } failHandler: {
                self.showAlert(title: "네트워크 통신에러", message: "다시 요청하시겠습니까?", button: "확인") {
                    self.backDropsCV.reloadData()
                }
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backDropsCV,
         infolabelView,
         synopsisLabel,
         synopsisMoreButton,
         castLabel,
         posterLabel].forEach{ contentView.addSubview($0) }
    }
    
    
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
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
    }
    
    override func configureDelegate() {
        backDropsCV.delegate = self
        backDropsCV.dataSource = self
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if backDrops.count > 5 {
            return 5
        } else {
            return backDrops.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropsCollectionViewCell.id, for: indexPath) as? BackDropsCollectionViewCell else { return UICollectionViewCell()}
        
        let backdrop = backDrops[indexPath.item]
        let url = "https://image.tmdb.org/t/p/original" + backdrop.filePath
        
        if let url = URL(string: url) {
            cell.backDropImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    
}
