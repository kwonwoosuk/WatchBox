//
//  NetworkManager.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import Foundation
import Alamofire

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
        case .trending:
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
    
    func callRequest<T: Decodable>(
            api: TMDBRequest,
            type: T.Type,
            completion: @escaping (Result<T, AFError>) -> Void
        ) {
            AF.request(api.endPoint, method: api.method, headers: api.header)
              .responseDecodable(of: T.self) { response in
                  switch response.result {
                  case .success(let data):
                      completion(.success(data))
                  case .failure(let error):
                      completion(.failure(error))
                  }
              }
        }
}

