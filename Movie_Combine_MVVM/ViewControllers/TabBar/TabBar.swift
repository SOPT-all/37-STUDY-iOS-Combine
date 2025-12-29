//
//  TabBar.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//


import UIKit

class TabBarController: UITabBarController,  UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabOne = UINavigationController(rootViewController:HomeViewController())
        let tabOneBarItem = UITabBarItem(title: "홈 화면", image: UIImage(systemName: "house"), tag: 0)
        tabOne.tabBarItem = tabOneBarItem
                
        let tabTwo = UINavigationController(rootViewController: SearchViewController())
        let tabTwoBarItem = UITabBarItem(title: "영화 검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = UINavigationController(rootViewController: SSEViewController())
        let tabThreeBarItem = UITabBarItem(title: "SSE", image: UIImage(systemName: "globe"), tag: 1)
        tabThree.tabBarItem = tabThreeBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
    }
}
