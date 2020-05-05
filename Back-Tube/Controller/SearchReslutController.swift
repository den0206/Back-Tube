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
    
    var nextPageToken : String? 
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
    
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        title = searchWord
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .black
        tableView.rowHeight = 100
        tableView.separatorColor = .white
        
        /// avoid overlay playerView
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 50, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 25, left: 0, bottom: 50, right: 0)
        
//        tableView.tableFooterView = UIView()
        let footer = SearchFooterView()
        footer.delegate = self
        footer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        tableView.tableFooterView = footer
        
        tableView.tableFooterView?.isHidden = true
        
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
                
                self.tabBarController?.showPresentLoadindView(false)

                guard let toatlResultCount = self.toatlResultCount else {return}
                
                print(toatlResultCount)
                if toatlResultCount >= self.searchResults.count {
                    self.tableView.tableFooterView?.isHidden = false
                } else {
                    self.tableView.tableFooterView?.isHidden = true
                }
            case .failed(let error) :
                print(error)
                
                self.tabBarController?.showPresentLoadindView(false)

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
            return
            
        }
        
        self.tabBarController?.showPresentLoadindView(true)
        
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
        
        self.tabBarController?.showPresentLoadindView(true)
        
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
                
                   self.tabBarController?.showPresentLoadindView(false)
                
                guard let toatlResultCount = self.toatlResultCount else {
                    print("No TOTAL")
                    return
                }
                
                if toatlResultCount >= self.searchResults.count {
                    self.tableView.tableFooterView?.isHidden = false
                }
                
                
            case .failed(let error) :
                
                print(error.localizedDescription)
                
                   self.tabBarController?.showPresentLoadindView(false)
                self.showErrorAlert(message: error.localizedDescription)
                
            }
        }
    }
    
    
}
