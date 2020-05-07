//
//  PlayingViewController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/04.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import YoutubeKit
import AVKit

private let reuseIdentifer = "Cell"

class PlayingViewController: UIViewController {
    
    var videoId : String? {
        didSet {
            getVideo()
        }
    }
    
    var tableView = UITableView()
    
    var relatedTitle : String?
    
    var relatedVideos = [SearchResult]() {
        didSet {
            print(relatedVideos.count)
            tableView.reloadData()
        }
    }
    
    var videoViewHeight : CGFloat?

    let playerViewController = AVPlayerViewControllerManager.shared.controller
    var player : AVPlayer?
    
    var videoContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.textColor = .white
        label.text = "再生中の音楽はありません"
        
        view.addSubview(label)
        
        let separateView = UIView()
        separateView.backgroundColor = .white
        
        view.addSubview(separateView)
        separateView.anchor(left : view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,width: view.frame.width, height: 0.75)
        
       
        label.center(inView: view)
        
        
        return view
    }()
    
    var bannerView : UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configVideoPlayer()
        configTableView()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(bannerView)
        bannerView.centerX(inView: view)
        bannerView.anchor(bottom: self.tabBarController?.tabBar.topAnchor,width: 320,height: 50)
        
        AdMobHelper.shared.setupBannerAd(adBaseView: bannerView, rootVC: self,bannerId: BannerID1)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    
  
    
    private func configVideoPlayer() {
        view.backgroundColor = .black
        videoViewHeight = view.frame.width * 9 / 16
        
        playerViewController.delegate = self
        
        videoContainerView.frame =  CGRect(x: 0, y: 0, width: view.frame.width, height: videoViewHeight!)
        
        view.addSubview(videoContainerView)
        
    }
    
    
    func getVideo() {
        
        print("Get")
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { (video, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                
            }
            AVPlayerViewControllerManager.shared.video = video
            
            
            self.playerViewController.view.frame = self.videoContainerView.bounds
            self.addChild(self.playerViewController)
            if let view = self.playerViewController.view {
                self.videoContainerView.addSubview(view)
            }
            
            self.playerViewController.didMove(toParent: self)
            
            self.tabBarController?.showPresentLoadindView(false)
            
            self.playerViewController.player?.play()
            
        }
        //
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: willEnterForeground)
        
        fetchRelatedVideos(videoId: videoId)
        
        
    }
    
    
    internal func willEnterForeground(notification : Notification) {
        
        AVPlayerViewControllerManager.shared.reconnectPlayer(rootViewController: AVPlayerViewControllerManager.shared.controller)

    }
    
    

    
    private func configTableView() {
        view.addSubview(tableView)
        
        tableView.frame = CGRect(x: 0, y: videoViewHeight!, width: view.frame.width, height: self.view.frame.height - videoViewHeight!)
        
        tableView.rowHeight = 100
        tableView.backgroundColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        tableView.isScrollEnabled = true
        
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 50, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 25, left: 0, bottom: 50, right: 0)
        
    }
    
    private func fetchRelatedVideos(videoId : String?) {
        guard let videoId = videoId else {return}
    
        let request =  SearchListRequest(part: [.snippet], filter: .relatedToVideoID(videoId), maxResults: 7,regionCode: "JP",resourceType: [.video])

        print("DEBUG : \(request)")

        YoutubeAPI.shared.send(request) { (request) in

            switch request {

            case .success(let response) :
                self.relatedVideos.removeAll(keepingCapacity: false)
                
                var results = [SearchResult]()
                for result in response.items {
                    results.append(result)
                }

                self.relatedVideos.append(contentsOf: results)

            case .failed(let error) :
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    

}

extension PlayingViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        var numberOfSections : Int = 0

        if !relatedVideos.isEmpty {
            numberOfSections = 1
            tableView.backgroundView = nil
        } else {

            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            
            noDataLabel.backgroundColor = .black
//            noDataLabel.text          = "再生中の音楽はありません"
//            noDataLabel.textColor     = UIColor.white
//            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }

        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! SearchResultCell
        
        cell.searchResult = relatedVideos[indexPath.row]
        cell.searchLabel.text = relatedTitle
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = relatedVideos[indexPath.row]
        
        guard let videoId = result.id.videoID else {return}

        self.videoId = videoId
        
//        weak var pvc = self.presentingViewController
//
//        self.dismiss(animated: true) {
//
//            let playView = playbackPlayer(videoId: videoId)
//            pvc?.present(playView, animated: true, completion: nil)
//        }
        
        
    }
    
    
}



//MARK: - Enter FullScreen

extension PlayingViewController : AVPlayerViewControllerDelegate {
    
//    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//
//        print("FullScreen")
//
//        self.playerViewController = playerViewController
//
//          NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: willEnterForeground)
//
//    }
//


}
