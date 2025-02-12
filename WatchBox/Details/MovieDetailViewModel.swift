//
//  MovieDetailViewModel.swift
//  WatchBox
//
//  Created by 권우석 on 2/13/25.
//

import Foundation

final class MovieDetailViewModel: BaseViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Int?> = Observable(nil)
        let likeButtonTapped: Observable<Int?> = Observable(nil)
        let synopsisMoreButtonTapped: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        let backdrops: Observable<[Backdrop]> = Observable([])
        let posters: Observable<[Posters]> = Observable([])
        let casts: Observable<[Cast]> = Observable([])
        
        let isLiked: Observable<Bool> = Observable(false)
        
        let showError: Observable<(title: String, message: String)?> = Observable(nil)
        let pageCount: Observable<Int> = Observable(0)
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.viewDidLoad.bind { [weak self] movieId in
            guard let movieId = movieId else { return }
            self?.fetchMovieData(movieId: movieId)
            self?.updateLikeStatus(movieId: movieId)
        }
        
        input.likeButtonTapped.bind { [weak self] movieId in
            guard let movieId = movieId else { return }
            self?.toggleLikeStatus(movieId: movieId)
        }
    }
    
    private func fetchMovieData(movieId: Int) {
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.callRequest(api: .image(movieId: movieId), type: Images.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.output.backdrops.value = response.backdrops
                self?.output.posters.value = response.posters
                
                if response.backdrops.count > 5 {
                    self?.output.pageCount.value = 5
                } else {
                    self?.output.pageCount.value = response.backdrops.count
                }
            case .failure:
                self?.output.showError.value = ("정보를 불러오지 못했습니다", "다시 요청하시겠습니까?")
            }
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.callRequest(api: .credit(movieId: movieId), type: Credit.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.output.casts.value = response.cast
            case .failure:
                self?.output.showError.value = ("정보를 불러오지 못했습니다", "다시 요청하시겠습니까?")
            }
            group.leave()
        }
        
        group.notify(queue: .main) { }
    }
    
    private func updateLikeStatus(movieId: Int) {
        let likedMovies = UserDefaults.standard.array(forKey: UserDefaultsKeys.likedMovies.rawValue) as? [Int] ?? []
        output.isLiked.value = likedMovies.contains(movieId)
    }
    
    private func toggleLikeStatus(movieId: Int) {
        var likedMovies = UserDefaults.standard.array(forKey: UserDefaultsKeys.likedMovies.rawValue) as? [Int] ?? []
        
        if likedMovies.contains(movieId) {
            likedMovies.removeAll { $0 == movieId }
        } else {
            likedMovies.append(movieId)
        }
        
        UserDefaults.standard.set(likedMovies, forKey: UserDefaultsKeys.likedMovies.rawValue)
        output.isLiked.value = likedMovies.contains(movieId)
        NotificationCenter.default.post(name: NSNotification.Name("LikeStatusChanged"), object: nil)
    }
    
    func getBackdrop(at index: Int) -> Backdrop? {
        guard index < output.backdrops.value.count else { return nil }
        return output.backdrops.value[index]
    }
    
    func getCast(at index: Int) -> Cast? {
        guard index < output.casts.value.count else { return nil }
        return output.casts.value[index]
    }
    
    func getPoster(at index: Int) -> Posters? {
        guard index < output.posters.value.count else { return nil }
        return output.posters.value[index]
    }
}
