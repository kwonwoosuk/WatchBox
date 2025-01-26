//
//  BaseViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/26/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureDelegate()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    func configureDelegate() { }
}
