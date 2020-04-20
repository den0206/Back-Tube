//
//  HomeController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController{
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureUI()
        
    }
    
 
    
    private func configureNav() {
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearence.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        
        
        navigationItem.title = "Home"
    }
    
    private func configureUI() {
         collectionView.backgroundColor = .white
         
     }
    
    
    
    
}
