//
//  SectionHeaderView.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class SectionHeaderView : UICollectionReusableView {
    
     var sectionTitleLabel : UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.text = "itle label"
        label.textColor = .white
            return label
        }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sectionTitleLabel)
        sectionTitleLabel.centerY(inView: self)
        sectionTitleLabel.anchor(left: leftAnchor, paddingLeft: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
