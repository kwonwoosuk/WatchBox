//
//  NetworkManager.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import Foundation
import Alamofire

// https://image.tmdb.org/t/p/original 위에 백드롭 패스로 이미지 불러올 수있음

enum TMDBRequest {
    case trending
    case search(searchQuery: String, page: Int)
    case image(movieId: Int)
    case credit(movieId: Int)
    
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }

    var endPoint: URL {
        switch self {
        case .trending:// url틀려놓고 뻘짓했다 진짜 흐린눈
            guard let url = URL(string: baseURL + "trending/movie/day?language=ko-KR&page=1") else {
                fatalError("정보를 불러올 수 없습니다.")
            }
            return url
        case .search(let searchQuery,let page):
            guard let url = URL(string: baseURL + "search/movie?query=\(searchQuery)&include_adult=false&language=ko-KR&page=\(page)") else {
                fatalError("파라미터 오류, 다시입력하세요.")
            }
            return url
                    
        case .image(let movieId):
            guard let url = URL(string: baseURL + "movie/\(movieId)/images") else {
                fatalError("정보를 불러올 수 없습니다.")
            }
            return url
        case .credit(let movieId):
            guard let url = URL(string: baseURL + "movie/\(movieId)/credits?language=ko-KR") else {
                fatalError("정보를 불러올 수 없습니다.")
            }
            return url
        }
        
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: HTTPHeaders {
        return [ "Authorization": "Bearer \(Key.TMDB)" ]
    }
    
}


final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(api: TMDBRequest,
                                   type: T.Type,
                                   completionHandler: @escaping (T) -> Void,
                                   failHandler: @escaping () -> Void
    ) {
        AF.request(api.endPoint, method: api.method, headers: api.header).responseDecodable(of: T.self) { response in
            switch response.result{
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                print(error)
                failHandler()
            }
        }
    }
    
}

/*
 
 트랜딩 https://api.themoviedb.org/3/trending/movie/day?language=ko-KR&page=1
 서치 https://api.themoviedb.org/3/search/movie?query=명량&include_adult=false&language=ko-KR&page=1
 이미지 https://api.themoviedb.org/3/movie/282631/images
 
 이미지는 근데 "/3KB32UjT3iL6YziK7760YzSiOEI.jpg" 이런식으로 던져주는데 / 백드롭 포스터 둘다
 https://image.tmdb.org/t/p/original 얘랑 붙여야지 조회가 가능하던데
 
 크레딧 https://api.themoviedb.org/3/movie/282631/credits?language=ko-KR
 
 
 
 
 */
