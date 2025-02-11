//
//  SearchResultViewModel.swift
//  WatchBox
//
//  Created by 권우석 on 2/12/25.
//

import Foundation

final class SearchResultViewModel: BaseViewModel {
    
    struct Input {
        let searchButtonClicked: Observable<String?> = Observable(nil)
        let prefetchRows: Observable<Int?> = Observable(nil)
        let viewDidLoad: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        let searchResults: Observable<[SearchResult]> = Observable([])
        let isEmptyResults: Observable<Bool> = Observable(true)
        let showError: Observable<String?> = Observable(nil)
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    private var page = 1
    private var totalPage = 0
    private var currentSearchQuery = ""
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.searchButtonClicked.bind { [weak self] query in
            guard let query = query else { return }
            self?.page = 1
            self?.searchMovies(query: query)
            self?.saveSearchKeyword(searchText: query)
        }
        
        input.prefetchRows.bind { [weak self] row in
            guard let self = self,
                  let row = row,
                  self.output.searchResults.value.count - 2 == row,
                  self.page <= self.totalPage else { return }
            
            self.page += 1
            self.searchMovies(query: self.currentSearchQuery, page: self.page)
        }
    }
    
    private func searchMovies(query: String, page: Int = 1) {
        NetworkManager.shared.callRequest(api: .search(searchQuery: query, page: page), type: Search.self) { [weak self] result in
            switch result {
            case .success(let response):
                if page == 1 {
                    self?.output.searchResults.value = response.results
                    self?.output.isEmptyResults.value = response.results.isEmpty
                } else {
                    self?.output.searchResults.value.append(contentsOf: response.results)
                }
                
                self?.totalPage = response.totalPages
                self?.currentSearchQuery = query
                
                
            case .failure:
                self?.output.showError.value = "검색결과가 없습니다."
            }
        }
    }
    
    private func saveSearchKeyword(searchText: String) {
        var searchHistory: [String] = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.searchHistory.rawValue) ?? []
        if let duplicateIndex = searchHistory.firstIndex(of: searchText) {
            searchHistory.remove(at: duplicateIndex)
        }
        searchHistory.insert(searchText, at: 0)
        UserDefaults.standard.set(searchHistory, forKey: UserDefaultsKeys.searchHistory.rawValue)
        print("After save - Updated history:", searchHistory)
    }
    
    func getMovie(at index: Int) -> SearchResult? {
        guard index < output.searchResults.value.count else { return nil }
        return output.searchResults.value[index]
    }
}
