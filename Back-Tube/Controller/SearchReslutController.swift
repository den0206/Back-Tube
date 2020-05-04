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

protocol SearchResultControllerDelegate : class {
    func didSelectResultVideo(videoId : String, relatedTitle : String)
}

class SearchResultController: UITableViewController {
    
    var searchWord : String
    
    weak var delegate : SearchResultControllerDelegate?
    
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
        
        
        fetchSeatchResult()
        
        configureTableView()
        
        print("DEBUG :\(self.tabBarController)")
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        title = searchWord
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
        
        /// avoid overlay playerView
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
//        tableView.tableFooterView = UIView()
        let footer = SearchFooterView()
        footer.delegate = self
        footer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        tableView.tableFooterView = footer
        
        
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        guard let toatlResultCount = toatlResultCount else {return}
        
        if toatlResultCount >= searchResults.count {
            tableView.tableFooterView?.isHidden = true
        }
        
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
            showErrorAlert(message: "ビデオが見つかりません")
            return}
        
        let playingVC = tabBarController?.viewControllers![2] as! PlayingViewController
        self.tabBarController?.selectedIndex = 2
        
        
        playingVC.videoId = videoId
        playingVC.relatedTitle = searchWord
        
        
//        let selectedVC = tabBarController?.viewControllers![2] as! UINavigationController
//        let playingVC = selectedVC.viewControllers[0] as! PlayingViewController
        
      
//s
//        let playView = playbackPlayer(videoId: videoId)
//        playView.relatedTitle = searchWord
//        present(playView, animated: true, completion: nil)
//
    }
    
    /// more button
    

    
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
