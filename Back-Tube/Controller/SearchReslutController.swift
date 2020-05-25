//
//  SearchReslutController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit
import GoogleMobileAds

private let reuseIdentifer = "Cell"


class SearchResultController: UITableViewController {
    
    var searchWord : String
    
    
    var nextPageToken : String? 
    var toatlResultCount : Int?
    
    var searchResults = [SearchResult]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var popupViewController = PopupViewController(searchType: .searchWord)
    
    init(_searchWord : String) {
        self.searchWord = _searchWord
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bannerView : UIView = {
        let view = UIView()
        return view
    }()
    
    var interstitial : GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchSeatchResult()
        
        configureTableView()
        
        self.tabBarController?.addChild(popupViewController)
        popupViewController.didMove(toParent: self.tabBarController)
        
        
        interstitial = createAndLoadInterstitial()
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        title = searchWord
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(bannerView)
        bannerView.centerX(inView: view)
        bannerView.anchor(bottom: self.tabBarController?.tabBar.topAnchor,width: 320,height: 50)
        
        /// banner 2
        
        if admob_test {
            AdMobHelper.shared.setupBannerAd(adBaseView: bannerView, rootVC: self,bannerId: AdMobID.bannerViewTest.rawValue)

        } else {
            AdMobHelper.shared.setupBannerAd(adBaseView: bannerView, rootVC: self,bannerId: AdMobID.adBanner2.rawValue)

        }
        
        
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
               
              
                print("エラー" + error.localizedDescription)
                
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]

        guard let videoId = result.id.videoID else {
            showErrorAlert(message: "ビデオが見つかりません")
            return

        }
        
        popupViewController.searchWord = searchWord
        popupViewController.videoId = videoId
        
        self.popupViewController.popView.alpha = 0
        
        self.tabBarController?.view.addSubview(self.popupViewController.view)
        
        UIView.animate(withDuration: 1) {
    
            self.popupViewController.popView.alpha = 1
            
        }
        
        //
//        self.tabBarController?.showPresentLoadindView(true)
//
//        let playingVC = tabBarController?.viewControllers![2] as! PlayingViewController
//        self.tabBarController?.selectedIndex = 2
//
//
//        playingVC.videoId = videoId
//        playingVC.relatedTitle = searchWord
//
//
    }
    
    /// more button
    
    /// add Favorite
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
   
        let favoriteAction = UIContextualAction(style: .normal, title: "お気に入りに追加") { (action, view, completion) in
            
            let title = self.searchResults[indexPath.item].snippet.title
            guard let videoId = self.searchResults[indexPath.item].id.videoID else {return}
            guard let thumbnail = self.searchResults[indexPath.item].snippet.thumbnails.default.url else {return}
            
            
            print(title, videoId,thumbnail)
            
            
            
            
        }
        favoriteAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        
        return configuration
        
    }
    

    
}

//MARK: - Show more

extension SearchResultController : SearchFooterViewDelegate {
    func handleShowMore(footerView: SearchFooterView) {
        
        self.tabBarController?.showPresentLoadindView(true)
        
        /// admob
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("NO READY")
        }
        
 
    }
    
    
}

extension SearchResultController : GADInterstitialDelegate {
    
    
    func createAndLoadInterstitial() -> GADInterstitial {
        /// Interstitial 1 (AD)
        let interstitial : GADInterstitial
           
        if admob_test == true {
            interstitial  = GADInterstitial(adUnitID: AdMobID.InterstitialTest.rawValue)
        } else {
            interstitial = GADInterstitial(adUnitID: AdMobID.inter1.rawValue)
        }
            
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        
        //MARK: - Show More

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
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        showErrorAlert(message: "広告が読み込めません")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("Will leave")
    }
}
