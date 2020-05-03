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
    
    let userDefault = UserDefaults.standard
    
    var suggestionsWords = [String]() {
        didSet {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var histrories = [String]() {
        didSet {
            tableView.reloadData()
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
        /// initial Set
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.sizeToFit()
        
        definesPresentationContext = true
        
        histrories = getHistories()
        
        
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

//        var numberOfSections : Int = 0
//
//        if !suggestionsWords.isEmpty {
//            numberOfSections = 1
//            tableView.backgroundView = nil
//        } else {
//
//            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//            noDataLabel.text          = "検索候補はありません"
//            noDataLabel.textColor     = UIColor.black
//            noDataLabel.textAlignment = .center
//            tableView.backgroundView  = noDataLabel
//            tableView.separatorStyle  = .none
//        }
//
//        return numberOfSections
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !suggestionsWords.isEmpty {
            return suggestionsWords.count

        } else {
            return histrories.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        
        var word : String
        if !suggestionsWords.isEmpty {
            word = suggestionsWords[indexPath.row]
        } else {
            word = histrories[indexPath.row]
        }
        
        cell.textLabel?.text = word
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var word : String
        
        if !suggestionsWords.isEmpty {
            word = suggestionsWords[indexPath.row]
        } else {
            word = histrories[indexPath.row]
        }
        
        
        let resultVC = SearchResultController(_searchWord: word)
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
    /// header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !suggestionsWords.isEmpty {
            return " "
        }
        
         return "検索履歴"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !suggestionsWords.isEmpty {
            return 0
        }
        
        return 35
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
        APISearvice.suggestWordRequest(suggestWord: searchController.searchBar.text!) { (suggestions, error) in
            
            self.suggestionsWords.removeAll()
            
            if error != nil {

                DispatchQueue.main.async {
                    self.showErrorAlert(message: error!.localizedDescription)
                }

                self.suggestionsWords = suggestions
                return
            }

            
            self.suggestionsWords = suggestions
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let word = searchBar.text else {return}
        
        /// add User Default for history
        addHistory(word: word)
        
        let resultVC = SearchResultController(_searchWord: word)
        navigationController?.pushViewController(resultVC, animated: true)
        
        
    }
    
    //MARK: - Histror Words
    
    private func getHistories() -> [String] {
        if let histrories = userDefault.array(forKey: "inputHistory") as? [String] {
            return histrories
        }
        
        return [String]()
    }
    
    private func addHistory(word : String) {
        var histories = getHistories()
        
        for history in histories {
            if word == history {
                return
            }
        }
        
        histories.insert(word, at: 0)
        userDefault.set(histories, forKey: "inputHistory")
        
        tableView.reloadData()
    }
    
    
    
}
