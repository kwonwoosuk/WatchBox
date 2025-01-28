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
        
        let secondTab = SecondTabViewController()
        secondTab.tabBarItem.image = UIImage(systemName: "film.stack")
        
        let thirdTab = ProfileViewController()
        thirdTab.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        
        
        
        let firstNav = UINavigationController(rootViewController: firstTab)
        let secondNav = UINavigationController(rootViewController: secondTab)
        let thirdNav = UINavigationController(rootViewController: thirdTab)
        
        
        setViewControllers([firstNav, secondNav, thirdNav], animated: true)
    }
    
    
    private func setupTabBarAppearance() { // 외형설정
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .accentBlue
    }
    
   
    
    
    
}
