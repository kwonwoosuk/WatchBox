//
//  TodayMovieViewModel.swift
//  WatchBox
//
//  Created by 권우석 on 2/12/25.
//

import Foundation

final class TodayMovieViewModel: BaseViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void?> = Observable(nil)
        let searchKeywordSelected: Observable<Int?> = Observable(nil)
        let movieSelected: Observable<Int?> = Observable(nil)
        let allClearTapped: Observable<Void?> = Observable(nil)
        let deleteKeyword: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        let todayMovies: Observable<[TrendingResult]> = Observable([])
        let searchedHistory: Observable<[String]> = Observable([])
        let profile: Observable<(imageName: String, name: String, date: Date)?> = Observable(nil)
        let showError: Observable<(title: String, message: String)?> = Observable(nil)
        let isEmptySearchHistory: Observable<Bool> = Observable(true)
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        // 뷰 로드될때 프로필 데이터, 최근검색어, 오늘의 영화셀 api호출
        input.viewWillAppear.bind { [weak self] _ in
            self?.fetchProfileData()
            self?.fetchSearchHistory()
            self?.fetchTodayMovies()
        }
        // 껐다켜면 초기화 되던 이
        input.allClearTapped.lazybind { [weak self] _ in
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.searchHistory.rawValue)
            self?.fetchSearchHistory()
        }
        
        input.deleteKeyword.bind { [weak self] index in
            if let index = index {
                var currentHistory = self?.output.searchedHistory.value ?? []
                currentHistory.remove(at: index)
                UserDefaults.standard.set(currentHistory, forKey: UserDefaultsKeys.searchHistory.rawValue)
                self?.fetchSearchHistory()
            }
        }
        
    }
    
    private func fetchProfileData() {
        let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.profileImageName.rawValue)
        let userName = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName.rawValue)
        let joinedDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.joinDate.rawValue) as? Date
        
        output.profile.value = (
            imageName: profileImageName ?? "profile_0",
            name: userName ?? "이름을 불러오지 못했습니다",
            date: joinedDate ?? Date()
        )
    }
    
    private func fetchSearchHistory() {
        DispatchQueue.main.async { [weak self] in
            let history = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.searchHistory.rawValue) ?? []
            self?.output.searchedHistory.value = history
            self?.output.isEmptySearchHistory.value = history.isEmpty
            
        }
    }
    
    private func fetchTodayMovies() {
        NetworkManager.shared.callRequest(api: .trending, type: Trending.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.output.todayMovies.value = response.results
            case .failure:
                self?.output.showError.value = ("네트워크 통신에러", "정보를 불러오지 못했습니다")
            }
        }
    }
    
    func getSelectedKeyword(at index: Int) -> String? {
        guard index < output.searchedHistory.value.count else { return nil }
        return output.searchedHistory.value[index]
    }
    
    func getSelectedMovie(at index: Int) -> TrendingResult? {
        guard index < output.todayMovies.value.count else { return nil }
        return output.todayMovies.value[index]
    }
}
