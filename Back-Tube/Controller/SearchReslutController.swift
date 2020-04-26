//
//  SearchReslutController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

private let reuseIdentifer = "Cell"

class SearchResultController: UITableViewController {
    
    var searchWord : String
    
    var nextPageToken : String? {
        didSet {
            print("DEBUG : \(nextPageToken)")
        }
    }
    
    var toatlResultCount : Int?
    
    var searchResults = [SearchResult]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(_searchWord : String) {
        self.searchWord = _searchWord
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        fetchSeatchResult()
        
        
        
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
        
//        tableView.tableFooterView = UIView()
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: reuseIdentifer)
        
    }
    
    //MARK: - API
    
    private func fetchSeatchResult() {
        
        let request = SearchListRequest(part: [.snippet], maxResults: 10,  pageToken: nil, searchQuery: searchWord, regionCode: "JP")
        
        YoutubeAPI.shared.send(request) { (result) in
            switch result {
            case .success(let response) :
                
                var results = [SearchResult]()
                for result in response.items {
                    results.append(result)
                }
                
                self.toatlResultCount = response.pageInfo.totalResults
                
                self.nextPageToken = response.nextPageToken
                self.searchResults = results
            case .failed(let error) :
                print(error)
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
}
 
extension SearchResultController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! SearchResultCell
        
        cell.searchResult = searchResults[indexPath.row]
        
        cell.searchLabel.text = searchWord
        
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        
        guard let videoId = result.id.videoID else {
            print("No")
            return}
        
        let videoLauncher = VideoLauncher(videoId: videoId)
        present(videoLauncher, animated: true, completion: nil)
    }
    
    /// more button
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let toatlResultCount = toatlResultCount else {return  UIView()}
        
        if toatlResultCount >= searchResults.count {
            
            let footerView = SearchFooterView()
            
            footerView.delegate = self
            
            return footerView
            
        }
        
        return UIView()
    }
    
 
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard let toatlResultCount = toatlResultCount else {return  0}
        
        if toatlResultCount >= searchResults.count {
             return 50
        }
        
        return 0
       
    }
    
}

//MARK: - Show more

extension SearchResultController : SearchFooterViewDelegate {
    func handleShowMore(footerView: SearchFooterView) {
        
        let request = SearchListRequest(part: [.snippet], maxResults: 10,  pageToken: nextPageToken,searchQuery: searchWord, regionCode: "JP")
        
        YoutubeAPI.shared.send(request) { (result) in
            
            switch result {
            case .success(let response):
                
                var results = [SearchResult]()
                for result in response.items {
                    results.append(result)
                }
                self.nextPageToken = response.nextPageToken
                
                self.searchResults.append(contentsOf: results)
                
                
            case .failed(let error) :
                print(error.localizedDescription)
                self.showErrorAlert(message: error.localizedDescription)
                
            }
        }
    }
    
    
}
