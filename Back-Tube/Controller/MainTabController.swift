//
//  MainTabController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class MainTabController : UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTabController()
    }
    
    func configureTabController() {
        
        let homeVC = HomeController()
        let nav1 = templetaNavigationController(image: #imageLiteral(resourceName: "home_unselected"), rootController: homeVC)
        
        let searchVC = SearchViewController()
        let nav2 = templetaNavigationController(image: #imageLiteral(resourceName: "search_unselected"), rootController: searchVC)
        
        viewControllers = [nav1,nav2]
    }
    
    private func templetaNavigationController(image : UIImage?, rootController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootController)
        nav.tabBarItem.image = image
     
        
        return nav
    }
    
}