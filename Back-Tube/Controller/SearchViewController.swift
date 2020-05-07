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
//
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var histrories = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    var timer : Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var bannerView : UIView = {
        let view = UIView()
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureTableView()
        
        
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(bannerView)
        bannerView.centerX(inView: view)
        bannerView.anchor(bottom: self.tabBarController?.tabBar.topAnchor,width: 320,height: 50)

        AdMobHelper.shared.setupBannerAd(adBaseView: bannerView, rootVC: self)
        
        
    }

   
    private func configureNav() {
        view.backgroundColor = .black
        navigationItem.searchController = searchController
        /// initial Set
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.searchBar.autocorrectionType = .no
        
        definesPresentationContext = true
        
        histrories = getHistories()
        
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .black
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        
       
        

    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !suggestionsWords.isEmpty, searchController.isActive  {
            return suggestionsWords.count

        } else {
            return histrories.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        
        var word : String
        if !suggestionsWords.isEmpty, searchController.isActive  {
            word = suggestionsWords[indexPath.row]
        } else {
            word = histrories[indexPath.row]
        }
        
        cell.textLabel?.text = word
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var word : String
        
        if !suggestionsWords.isEmpty,searchController.isActive  {
            word = suggestionsWords[indexPath.row]
        } else {
            word = histrories[indexPath.row]
        }
        
        self.tabBarController?.showPresentLoadindView(true)
        
        
        let resultVC = SearchResultController(_searchWord: word)
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        tableView.separatorColor = .white
    }
    
    
    /// header

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !suggestionsWords.isEmpty {
            return 0
        }
        
        return 35
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        view.backgroundColor = .black
        
        let headerTitle : UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.text = "検索履歴"
            return label
        }()
        
        headerView.addSubview(headerTitle)
        headerTitle.centerY(inView: headerView, leftAnchor: headerView.leftAnchor, paddingLeft: 8)
        
        return headerView
    }
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !suggestionsWords.isEmpty {
            return nil
        }
        
        let deleteActiuon = UIContextualAction(style: .destructive, title: "削除") { (action, view, completion) in
            
            
            self.deleteHistory(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteActiuon])
        return configuration
        
    }
}

extension SearchViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
       
        
        if let searchText = searchController.searchBar.text , !searchText.isEmpty {
            
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(serachSuggestions), userInfo: nil, repeats: false)
            
        }else {
            suggestionsWords.removeAll(keepingCapacity: false)
        }
        
    }
    
    @objc func serachSuggestions() {
        APISearvice.suggestWordRequest(suggestWord: searchController.searchBar.text!) { (suggestions, error) in
            
            self.suggestionsWords.removeAll(keepingCapacity: false)
            
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
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        searchController.searchResultsController?.view.isHidden = false
        
        return true
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
        
        if histories.count == 10 {
            histories.removeLast()
        }
        
        histories.insert(word, at: 0)
        userDefault.set(histories, forKey: "inputHistory")
        
        tableView.reloadData()
    }
    
    private func deleteHistory(index : Int) {
        histrories.remove(at: index)
        userDefault.set(histrories, forKey: "inputHistory")
    }
    
    
    
}

