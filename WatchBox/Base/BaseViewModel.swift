//
//  BaseViewModel.swift
//  WatchBox
//
//  Created by 권우석 on 2/11/25.
//

import Foundation

protocol BaseViewModel {
    // 형태를 정해둬서 시간이 지나 다시 코드를 볼때 MVVM구조에서 input인지 output인지 명시적으로 알기 위해 어느정도 프로토콜을 사용함으로써 규격을 강제화 -> 일관적
    associatedtype Input
    associatedtype Output
    
    func transform()
}

