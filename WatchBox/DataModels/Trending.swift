//
//  Trending.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//
// 오늘의 영화 영역에서 사용
import Foundation


struct Trending: Codable {
    let page: Int
    let results: [Result]
}


struct Result: Codable {
    let backdropPath: String
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let genreIDS: [Int]
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        
    }
}
