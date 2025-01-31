//
//  SecondTabViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import UIKit
import Lottie
import SnapKit

class SecondTabViewController: BaseViewController {

    
    private let animationImageView = LottieAnimationView(name: "travel")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationImageView.play()
    }
    
    override func configureHierarchy() {
        view.addSubview(animationImageView)
    }
    
    override func configureLayout() {
        animationImageView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    override func configureView() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "공사중"
        navigationController?.navigationBar.tintColor = .accentBlue
        
    }
    
}
