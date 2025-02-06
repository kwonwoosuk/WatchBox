//
//  SearchResultViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/30/25.
//

import UIKit
import SnapKit
//fourthweek / kakaobook...
class SearchResultViewController: BaseViewController {
    
    
    let movieSearchBar = UISearchBar()
    lazy var resultTableView = UITableView()
    let resultLabel = UILabel()
    var resultList: [SearchResult] = []
    
    private  var page = 1
    private var totalPage = 0
    private var currentSearchBarText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.isHidden = true
        
    }
    
    private func updateUI() {
        resultLabel.isHidden = !resultList.isEmpty
        resultTableView.isHidden = resultList.isEmpty
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieSearchBar.resignFirstResponder()
    }
    
    override func configureHierarchy() {
        [movieSearchBar, resultTableView, resultLabel].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        movieSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(movieSearchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        navigationItem.title = "영화 검색"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .accentBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        movieSearchBar.placeholder = "영화를 검색해보세요"
        movieSearchBar.searchTextField.textColor = .white
        movieSearchBar.barTintColor = .black
        if movieSearchBar.text?.isEmpty == true {
            movieSearchBar.becomeFirstResponder()
        }
        resultLabel.text = "원하는 검색결과를 찾지못했습니다"
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        resultLabel.textColor = .white
        
        resultTableView.rowHeight = 120
        resultTableView.keyboardDismissMode = .onDrag
        resultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
        resultTableView.backgroundColor = .clear
        resultTableView.separatorStyle = .singleLine
        resultTableView.separatorColor = .darkGray
        resultTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func configureDelegate() {
        movieSearchBar.delegate = self
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.prefetchDataSource = self
    }
    
    func callRequest(query: String, page: Int = 1) {
        NetworkManager.shared.callRequest(api: .search(searchQuery: query, page: page), type: Search.self) { result in
            switch result {
            case .success(let response):
                if page == 1 {
                    self.resultList = response.results
                } else {
                    self.resultList.append(contentsOf: response.results)
                }
                
                self.totalPage = response.totalPages
                self.currentSearchBarText = query
                
                DispatchQueue.main.async {
                    self.resultTableView.reloadData()
                    self.updateUI()
                }
                
            case .failure:
                print("검색결과가 없습니다.")
            }
        }
    }
}


extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces),
              !searchText.isEmpty else { return }
        
        callRequest(query: searchText)
        
        saveSearchKeyword(searchText: searchText)
        searchBar.resignFirstResponder()
    }
    
    private func saveSearchKeyword(searchText: String) {
        var searchHistory: [String] = UserDefaults.standard.stringArray(forKey: "SearchHistory") ?? []
        // 중복된것 제거하고 새로운 검색어 맨앞에 추가
        if let duplicateIndex = searchHistory.firstIndex(of: searchText) {
            searchHistory.remove(at: duplicateIndex)
        }
        searchHistory.insert(searchText, at: 0)
        UserDefaults.standard.set(searchHistory, forKey: "SearchHistory")
    }
}


extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource ,UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if resultList.count - 2 == item.row && page <= totalPage {
                page += 1
                callRequest(query: currentSearchBarText, page: page)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let data = resultList[indexPath.row]
        cell.configureData(data: data)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.navigationItem.title = resultList[indexPath.row].title
        vc.movieId = resultList[indexPath.row].id
        vc.releaseDate = resultList[indexPath.row].releaseDate
        vc.voteAverage = resultList[indexPath.row].voteAverage
        vc.overview = resultList[indexPath.row].overview
        vc.genreIDS = resultList[indexPath.row].genreIDS
        
        
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

    

