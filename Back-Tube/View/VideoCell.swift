//
//  VideoCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class VideoCell : UICollectionViewCell {
    
    private let thumbnailImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let channelImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimension(width: 43, height: 43)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 43 / 2
        return iv
    }()
    
    
    private let titleLabel : UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 16)
           label.textColor = .black
           label.text = "Title label"
           label.numberOfLines = 2
           
           return label
       }()
       
       private let subTitleLabel : UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14)
           label.textColor = .lightGray
           label.text = "Subtitle"
           return label
       }()
    
    private let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    //MARK: - Parts
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(thumbnailImageView)
        
        thumbnailImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,paddongTop: 8, paddingLeft: 16, paddingRight: 16,width: self.frame.width, height: 235)
        
        addSubview(channelImageView)
        channelImageView.anchor(top : thumbnailImageView.bottomAnchor, left: leftAnchor,paddongTop: 8,paddingLeft: 16,paddiongBottom: 8 )
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stack.axis = . vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top : thumbnailImageView.bottomAnchor, left: channelImageView.rightAnchor, right:  rightAnchor , paddongTop: 8,paddingLeft: 16,paddingRight: 16)
        //        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeightConstraint!.constant).isActive = true
        
        
        
        addSubview(separatorView)
        separatorView.anchor(left : leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingLeft: 16, paddingRight: 16, height: 0.75)
        
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
