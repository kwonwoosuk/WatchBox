//
//  TabBarController.swift
//  WatchBox
//
//  Created by 권우석 on 1/27/25.
//

import UIKit

class TabBarController: UITabBarController {

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        setupTabBarAppearance()
        
        
    }
    
    private func configureTabBarController() {
        tabBar.delegate = self
        
        let firstTab = MainViewController()
        firstTab.tabBarItem.image = UIImage(systemName: "popcorn")
        firstTab.tabBarItem.title  = "CINEMA"
        let secondTab = SecondTabViewController()
        secondTab.tabBarItem.image = UIImage(systemName: "film.stack")
        secondTab.tabBarItem.title = "UPCOMING"
        let thirdTab = SettingViewController()
        thirdTab.tabBarItem.title = "PROFILE"
        thirdTab.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        
        let firstNav = UINavigationController(rootViewController: firstTab)
        firstNav.view.backgroundColor = .black
        
        let secondNav = UINavigationController(rootViewController: secondTab)
        secondNav.view.backgroundColor = .black
        
        let thirdNav = UINavigationController(rootViewController: thirdTab)
        thirdNav.view.backgroundColor = .black
        
        
        setViewControllers([firstNav, secondNav, thirdNav], animated: true)
    }
    
    
    private func setupTabBarAppearance() { // 외형설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        tabBar.standardAppearance = appearance //  스크롤 엣지효과가 없을때
        tabBar.scrollEdgeAppearance = appearance // " 있을때
        tabBar.barTintColor = .black
        
        tabBar.tintColor = .accentBlue
    }
    
   
    
    
    
}
