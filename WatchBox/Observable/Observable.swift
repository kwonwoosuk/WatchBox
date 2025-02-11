//
//  Observable.swift
//  WatchBox
//
//  Created by 권우석 on 2/12/25.
//

import Foundation


class Observable<T> {
    
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
    
    func lazybind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}
