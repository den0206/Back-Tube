//
//  VideoLauncher.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

class VideoLauncher: UIViewController {
    
    let videoId : String
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
        view.backgroundColor = .white
        
        player = YTSwiftyPlayer(
                    frame: CGRect(x: 0, y: 0, width: 640, height: 480),
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
    
    
}

extension VideoLauncher : YTSwiftyPlayerDelegate {
    func playerReady(_ player: YTSwiftyPlayer) {
        
    }
    
    
}
