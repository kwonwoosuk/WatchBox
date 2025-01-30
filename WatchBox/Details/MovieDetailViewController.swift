//
//  MovieDetailViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/30/25.
//

import UIKit

class MovieDetailViewController: BaseViewController {
    var movieId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
//        print(movieId)
    }
    
    
    
//    override func configureHierarchy() {
//        <#code#>
//    }
//
//    
//    
//    override func configureLayout() {
//        <#code#>
//    }
//    
    
    override func configureView() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .accentBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    
    
//    override func configureDelegate() {
//        <#code#>
//    }
}
