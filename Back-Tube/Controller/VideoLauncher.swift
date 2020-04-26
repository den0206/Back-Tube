//
//  VideoLauncher.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

private let reuseIdentifer = "Cell"

class VideoLauncher: UIViewController {
    
    let videoId : String
    var tableView = UITableView()
    
    var videoViewHeight : CGFloat?
    
    private var player : YTSwiftyPlayer!
    
    init(videoId : String) {
        
        self.videoId = videoId
        super.init(nibName: nil, bundle: nil)
        
        
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(videoId)
        
        configVideoPlayer()
        configTableView()
       
        fetchRelatedVideos()
    }
    
    private func configVideoPlayer() {
        view.backgroundColor = .white
        
        videoViewHeight = view.frame.width * 9 / 16
        
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: videoViewHeight!),
            playerVars: [.videoID(videoId), VideoEmbedParameter.showRelatedVideo(false)])
        
        // Enable auto playback when video is loaded
        player.autoplay = true
        
        // Set player view.
        view.addSubview(player)
        
        // Set delegate for detect callback information from the player.
        player.delegate = self
        
        // Load the video.
        player.loadPlayer()
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        
        tableView.frame = CGRect(x: 0, y: videoViewHeight!, width: view.frame.width, height: self.view.frame.height - videoViewHeight!)
        
        tableView.rowHeight = 100
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
    
    private func fetchRelatedVideos() {
        
        let request =  SearchListRequest(part: [.snippet], filter: .relatedToVideoID(videoId), maxResults: 7,regionCode: "JP",resourceType: [.video])
        
        YoutubeAPI.shared.send(request) { (request) in
            
            switch request {
            case .success(let response) :
                print(response)
            case .failed(let error) :
                print(error)
            }
        }
        
        
        
    }
    
    
}

//MARK: UItablevide Delegate

extension VideoLauncher : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! SearchResultCell
        
        return cell
    }
    
    
}

extension VideoLauncher : YTSwiftyPlayerDelegate {
    func playerReady(_ player: YTSwiftyPlayer) {
        
    }
    
    
}
