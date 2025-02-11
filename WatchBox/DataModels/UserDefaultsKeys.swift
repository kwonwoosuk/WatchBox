//
//  UserDefaultsKeys.swift
//  WatchBox
//
//  Created by 권우석 on 2/10/25.
//

import Foundation

enum UserDefaultsKeys: String {
    case isJoined = "isJoined"
    case joinDate = "JoinDate"
    case userName = "UserName"
    case profileImageName = "profileImageName"
    case searchHistory = "SearchHistory"
    case likedMovies = "LikedMovies"
    
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
