//
//  Credit.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import Foundation

struct Case: Codable {
    let id: Int
    let cast: [Cast]
    
}

struct Cast: Codable {
    let name: String
    let character: String?
    let profilePath: String?
}
