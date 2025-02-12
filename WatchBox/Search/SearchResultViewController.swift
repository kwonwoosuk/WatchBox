//
//  SearchResultViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/30/25.
//

import UIKit
import SnapKit

final class SearchResultViewController: BaseViewController {
    
    
    private let viewModel = SearchResultViewModel()
    
    let movieSearchBar = UISearchBar()
    private lazy var resultTableView = UITableView()
    private let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        resultLabel.isHidden = true
    }
    
    private func bindData() {
        viewModel.output.searchResults.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.resultTableView.reloadData()
            }
        }
        
        viewModel.output.isEmptyResults.bind { [weak self] isEmpty in
            self?.resultLabel.isHidden = !isEmpty
            self?.resultTableView.isHidden = isEmpty
        }
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
    
    func callRequest(query: String) {
        viewModel.input.searchButtonClicked.value = query
    }
}


extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces),
              !searchText.isEmpty else { return }
        
        callRequest(query: searchText)
        
        viewModel.input.searchButtonClicked.value = searchText
        searchBar.resignFirstResponder()
    }
}


extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource ,UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            viewModel.input.prefetchRows.value = item.row
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.output.searchResults.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        if let movie = viewModel.getMovie(at: indexPath.row) {
            cell.configureData(data: movie)
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel.getMovie(at: indexPath.row) else { return }
        
        let vc = MovieDetailViewController()
        vc.navigationItem.title = movie.title
        vc.movieId = movie.id
        vc.releaseDate = movie.releaseDate
        vc.voteAverage = movie.voteAverage
        vc.overview = movie.overview
        vc.genreIDS = movie.genreIDS
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}



