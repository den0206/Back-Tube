//
//  WeeklyCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/02.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class addCell : UICollectionViewCell {
    //MARK: - Parts

    let addImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimension(width: 40, height: 40)
        iv.tintColor = .white
        iv.image = UIImage(systemName: "plus")
        return iv
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 35 / 2
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 2
        
        addSubview(addImageView)
        addImageView.center(inView: self)
        
     
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
//
//    func setlabel() {
//
//        guard let word = word else {return}
//
//        addImageView.isHidden = true
//
//        addSubview(stickyLabel)
//        stickyLabel.center(inView: self)
//        stickyLabel.text = word
//
//
//    }
}
