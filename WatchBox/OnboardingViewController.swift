//
//  ViewController.swift
//  WatchBox
//
//  Created by 권우석 on 1/24/25.
//

import UIKit
import SnapKit


final class OnboardingViewController: BaseViewController {

    
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionsLabel = UILabel()
    private let startButton  = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    override func configureHierarchy() {
        [imageView, startButton, titleLabel, descriptionsLabel].forEach{ view.addSubview($0) }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        descriptionsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionsLabel.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(8)
            make.trailing.equalTo(view.snp.trailing).offset(-8)
            make.height.equalTo(48)
        }
    }

    override func configureView() {
        view.backgroundColor = .black
        imageView.image = UIImage(named: "onboarding")
        
        titleLabel.text = "Onboarding"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        let traits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitItalic]
        let OnboardingFont = UIFont.systemFont(ofSize: 35, weight: .heavy).fontDescriptor.withSymbolicTraits(traits)
        titleLabel.font = UIFont(descriptor: OnboardingFont!, size: 35)
        
        descriptionsLabel.text = "당신의 영화 취향과 트렌드,\n WatchBox와 함께 찾아보세요."
        descriptionsLabel.textColor = .white
        descriptionsLabel.textAlignment = .center
        descriptionsLabel.numberOfLines = 2
        descriptionsLabel.font = .boldSystemFont(ofSize: 15)
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.accentBlue , for: .normal)
        startButton.setTitleColor(.white, for: .highlighted)
        startButton.backgroundColor = .clear
        
        startButton.layer.borderColor = UIColor.accentBlue.cgColor
        startButton.layer.borderWidth = 3
        startButton.layer.cornerRadius = 22
        startButton.clipsToBounds = true
    }

    @objc
    func startButtonTapped() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

