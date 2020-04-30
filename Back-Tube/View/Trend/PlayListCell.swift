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
    
    var video : SearchResult? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private let playlistImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.setDimension(width: 150, height: 150)
        iv.layer.cornerRadius = 35 / 2
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let titleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = "Evening Music"
     
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        layer.cornerRadius = 35 / 2
//
        addSubview(playlistImageView)
        playlistImageView.anchor(top : topAnchor,left: leftAnchor,right: rightAnchor)
        
        addSubview(titleLabel)
            titleLabel.anchor(top : playlistImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,paddongTop: 10,paddingLeft: 8,paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
     guard let searchResult =  video else {return}
     titleLabel.text = searchResult.snippet.title
     
     guard let thumanail = searchResult.snippet.thumbnails.medium.url else {return}
     let url = URL(string: thumanail)
     
     playlistImageView.sd_setImage(with: url)
     
    }
}
