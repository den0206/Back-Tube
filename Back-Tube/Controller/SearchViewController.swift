//
//  SearchViewController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        
    }
    
    private func configureNav() {
        view.backgroundColor = .white
        
      
        
        navigationItem.searchController = searchController
    
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        

    }
    
    //MARK: - Actions
    
    @objc func handleCancel() {
        
    }
}

extension SearchViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        print(searchController.searchBar.text)
    }
    
    
    
}
