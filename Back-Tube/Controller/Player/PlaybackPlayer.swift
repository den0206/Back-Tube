//
//  PlaybackPlayer.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/30.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//


import UIKit
import XCDYouTubeKit
import AVKit

private let reuseIdentifer = "Cell"

class playbackPlayer: UIViewController {
    
    let videoId : String
    var tableView = UITableView()
    
    var relatedTitle : String?

    var videoViewHeight : CGFloat?
    

    
    init(videoId : String) {
        
        self.videoId = videoId
        super.init(nibName: nil, bundle: nil)
        
        
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        print(videoId)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { (video, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                
            }
            AVPlayerViewControllerManager.shared.video = video
            self.present(AVPlayerViewControllerManager.shared.controller, animated: true) {
                AVPlayerViewControllerManager.shared.controller.player?.play()
            }
            
        }
        
    
      
//        configTableView()
//
//        fetchRelatedVideos()
        
    }
    
    private func configVideoPlayer() {
        view.backgroundColor = .white
        
        videoViewHeight = view.frame.width * 9 / 16

        
       
    }

    
    private func configTableView() {
        view.addSubview(tableView)
        
        tableView.frame = CGRect(x: 0, y: videoViewHeight!, width: view.frame.width, height: self.view.frame.height - videoViewHeight!)
        
        tableView.rowHeight = 100
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: reuseIdentifer)
        
       
        tableView.isScrollEnabled = true
        
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
    
    private func fetchRelatedVideos() {
        
//        let request =  SearchListRequest(part: [.snippet], filter: .relatedToVideoID(videoId), maxResults: 7,regionCode: "JP",resourceType: [.video])
//
//        print("DEBUG : \(request)")
//
//        YoutubeAPI.shared.send(request) { (request) in
//
//            switch request {
//
//            case .success(let response) :
//                var results = [SearchResult]()
//                for result in response.items {
//                    results.append(result)
//                }
//
//                self.relatedVideos.append(contentsOf: results)
//
//            case .failed(let error) :
//                print(error)
//            }
//        }
    }
    

}



