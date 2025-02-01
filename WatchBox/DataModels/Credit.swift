//
//  Credit.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import Foundation

struct Credit: Codable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Codable {
    let name: String
    let character: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case name
        case character
    }
}
