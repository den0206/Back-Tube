//
//  WeeklyCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/02.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class WeeklyCell : UICollectionViewCell {
    //MARK: - Parts
    
    let weekLabel : UILabel = {
        let label = UILabel()
        label.text = "月"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 45)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(weekLabel)
        weekLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
