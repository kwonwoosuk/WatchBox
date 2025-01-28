//
//  Search.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import Foundation

struct Search: Codable {
    let page: Int
    let results: [SearchResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct SearchResult: Codable {
    let id: Int
    let backdropPath: String
    let overview: String
    let genreIDS: [Int]
    let posterPath,
        releaseDate,
        title: String
    let voteAverage: Double
    

    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case overview
        case genreIDS = "genre_ids"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        
    }
}
