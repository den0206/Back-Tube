//
//  playerView.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/04.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class PlayerView : UIView {
    //MARK: - Parts
    
    private let videoContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .green
    
        return view
    }()
    
    private let centerLine : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .backGroundColor
        print(frame.width)
        videoContainerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        addSubview(videoContainerView)
        
        addSubview(centerLine)
        centerLine.centerX(inView: self)
        centerLine.setDimension(width: 0.5, height: 100)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
