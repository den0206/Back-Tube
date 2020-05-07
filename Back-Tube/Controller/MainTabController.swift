//
//  MainTabController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit



class MainTabController : UITabBarController {
    
    /// playerView
    //    private let playerView = PlayerView()
    
    
    private var popupViewController = PopupViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        configureTabController()
        
        addChild(popupViewController)
        popupViewController.didMove(toParent: self)
        
        
    }
    
//    override func viewWillLayoutSubviews() {
//
//        configurePlayerView()
//    }
    
    //MARK: - UI
    
    func configureTabController() {
        
        let trendVC = TrendViewController()
        let nav1 = templetaNavigationController(image: #imageLiteral(resourceName: "home_unselected"), title : "Home",rootController: trendVC)
        
        let searchVC = SearchViewController()
        let nav2 = templetaNavigationController(image: #imageLiteral(resourceName: "search_unselected"), title : "Search", rootController: searchVC)
        
        let playingVC = PlayingViewController()
        playingVC.tabBarItem.image =  UIImage(systemName: "music.house")
        playingVC.tabBarItem.title = "Now"
//        let nav3 = templetaNavigationController(image: UIImage(systemName: "music.house"), title: "Now", rootController: playingVC)
        
        viewControllers = [nav1,nav2,playingVC]
        self.tabBar.barTintColor = .black
        
        UITabBar.appearance().tintColor = .red
        tabBar.unselectedItemTintColor = .white
    }
    
//    private func configurePlayerView() {
//
//        ///ios11 以降
//        let tabvarHeight = self.tabBar.frame.height + self.view.safeAreaInsets.bottom + 100
//        view.addSubview(playerView)
//
//
////        playerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//        playerView.anchor(bottom : self.tabBar.topAnchor, width: view.frame.width,height: 100)
//
//    }
//
    private func templetaNavigationController(image : UIImage?, title :String, rootController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootController)
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        //        appearence.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        appearence.backgroundColor = UIColor.black
        
        /// navigationController border Color
        appearence.shadowColor = .clear
        
        nav.navigationBar.standardAppearance = appearence
        nav.navigationBar.compactAppearance = appearence
        nav.navigationBar.scrollEdgeAppearance = appearence
        
        nav.navigationBar.tintColor = .white
        nav.navigationBar.layer.borderColor = UIColor.white.cgColor
        
        
//        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
                
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        
        return nav
    }
    
}


