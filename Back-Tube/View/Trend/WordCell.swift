//
//  WeeklyCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/02.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class WordCell : UICollectionViewCell {
    //MARK: - Parts
    
    var word : String? {
        didSet {
            setlabel()
        }
    }
    
    let stickyLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 35 / 2
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 2
        
        
        addSubview(stickyLabel)
        stickyLabel.center(inView: self)
        
     
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    func setlabel() {
        
        guard let word = word else {return}
        
        
        stickyLabel.text = word
        
        
    }
}

