//
//  PlayListCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit
import SDWebImage

class PlayListCell : UICollectionViewCell {
    
    var video : Video? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private let PlaylistImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "home_unselected")
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let TitleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = "Evening Music"
     
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(PlaylistImageView)
        PlaylistImageView.anchor(top : topAnchor,left: leftAnchor,right: rightAnchor,height: 240)
        
        addSubview(TitleLabel)
            TitleLabel.anchor(top : PlaylistImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,paddongTop: 10,paddingLeft: 8,paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        guard let video = video else {return}
        
        guard let snipet = video.snippet else {return}
        TitleLabel.text = snipet.title
        
        guard let thumbnail = snipet.thumbnails.medium.url else {return}
        let url = URL(string: thumbnail)
        PlaylistImageView.sd_setImage(with: url)
        
        
        
        
    }
}
