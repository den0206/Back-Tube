//
//  SearchResultCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/24.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

class SearchResultCell : UITableViewCell {
    
    var searchResult : SearchResult? {
        didSet {
            guard let searchResult = searchResult else {return}
            titleLabel.text = searchResult.snippet.title
        }
    }
    
    //MARK: - parts
    let containerView : UIView = {
        let view = UIView()
 
        return view
    }()
    
    let searchLabel : UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let thumbnailImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        return iv
        
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
        
        addSubview(thumbnailImageView)
        thumbnailImageView.anchor(top : topAnchor, bottom: bottomAnchor, right: rightAnchor, width: self.frame.width / 2, height: 100)
        
        addSubview(containerView)
        containerView.centerY(inView: thumbnailImageView)
        containerView.anchor(left : leftAnchor,right: thumbnailImageView.leftAnchor,width: frame.width / 2, height: 100)
        
        let stack = UIStackView(arrangedSubviews: [searchLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        containerView.addSubview(stack)
        
        stack.centerX(inView: containerView, topAnchor: topAnchor, paddingTop: 10)
        stack.anchor(left : leftAnchor, right: thumbnailImageView.leftAnchor)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
