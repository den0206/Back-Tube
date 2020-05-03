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
        view.backgroundColor = .lightGray
        
        configureTabController()
        
    }
    
    func configureTabController() {
        
        let trendVC = TrendViewController()
        let nav1 = templetaNavigationController(image: #imageLiteral(resourceName: "home_unselected"), title : "Home",rootController: trendVC)
        
        let searchVC = SearchViewController()
        let nav2 = templetaNavigationController(image: #imageLiteral(resourceName: "search_unselected"), title : "Search", rootController: searchVC)
        
        viewControllers = [nav1,nav2]
        self.tabBar.barTintColor = .black
        
        UITabBar.appearance().tintColor = .red
        tabBar.unselectedItemTintColor = .white
    }
    
    private func templetaNavigationController(image : UIImage?, title :String, rootController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootController)
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        //        appearence.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        appearence.backgroundColor = UIColor.black
        
        nav.navigationBar.standardAppearance = appearence
        nav.navigationBar.compactAppearance = appearence
        nav.navigationBar.scrollEdgeAppearance = appearence
        
        nav.navigationBar.tintColor = .white
        nav.navigationBar.isTranslucent = true
        
//        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
                
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        
        return nav
    }
    
}
