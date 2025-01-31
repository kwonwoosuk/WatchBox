//
//  Image.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import Foundation


struct Images: Codable {
    let id: Int?
    let backdrops: [Backdrop]
    let posters: [Posters]
}

struct Backdrop: Codable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

struct Posters: Codable {
    let filePath: String?
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
