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

    var radio : Radio? {
        didSet {
            configure()
        }
    }
    
    var favorite : Favorite? {
        didSet {
            configureFavorite()
        }
    }
    
    //MARK: - Parts
    
    let weeklyLable : UILabel? = {
        let label = UILabel()
        label.text = "Weekly"
        return label
    }()
    
    let playlistImageView : UIImageView = {
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
        
        
        addSubview(playlistImageView)
        playlistImageView.anchor(top : topAnchor,left: leftAnchor,right: rightAnchor)
        
        addSubview(titleLabel)
            titleLabel.anchor(top : playlistImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,paddongTop: 10,paddingLeft: 8,paddingRight: 8)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        guard let radio = radio else {return}
        titleLabel.text = radio.title
        playlistImageView.image = radio.thumbnailImage
    }
    
    private func configureFavorite() {
        
        guard let favorite = favorite else {return}
        
        titleLabel.text = favorite.title
        
        let thumbnailUrl = URL(string: favorite.thumbnailUrl)
        playlistImageView.sd_setImage(with: thumbnailUrl)
    }
 

}
