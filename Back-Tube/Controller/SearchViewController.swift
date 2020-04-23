//
//  SearchViewController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
private let reuseIdentifer = "Cell"

class SearchViewController : UITableViewController {
    
    var suggestionsWords = [String]() {
        didSet {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(suggestionsWords)
        }
    }
    
    var timer : Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureTableView()
        
    }
    
    private func configureNav() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
    
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        

    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionsWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        cell.textLabel?.text = suggestionsWords[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = suggestionsWords[indexPath.row]
        
        print(word)
    }
}

extension SearchViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text , !searchText.isEmpty {
           
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(serachSuggestions), userInfo: nil, repeats: false)
            
        }

    }
    
    @objc func serachSuggestions() {
        APISearvice.suggestWordRequest(suggestWord: searchController.searchBar.text!) { (suggestions) in
            self.suggestionsWords.removeAll()
            
            self.suggestionsWords = suggestions
            
        }
        
    }
    
    
    
}
