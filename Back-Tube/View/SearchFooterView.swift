//
//  SearchFooterView.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/25.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol SearchFooterViewDelegate {
    func handleShowMore(footerView : SearchFooterView)
}

class SearchFooterView : UIView {
    
    var delegate : SearchFooterViewDelegate?
    
    //MARK: - parts
    
    let showMoreButton : UIButton = {
        let button = UIButton(type: .system)
        let attributeTitle =  (NSMutableAttributedString(string: "Show More", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSMutableAttributedString.Key.foregroundColor : UIColor.white]))
   
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)

        button.layer.cornerRadius = 35 / 2
        button.layer.borderWidth = 1
        button.layer.borderColor =  UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleShowMore), for: .touchUpInside)
        
        /// animation
        button.addTarget(self, action: #selector(whenPush(_ :)), for: .touchDown)
        button.addTarget(self, action: #selector(whenSeparate(_ :)), for: .touchUpInside)

     
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubview(showMoreButton)

        showMoreButton.center(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleShowMore() {
        delegate?.handleShowMore(footerView: self)
    }
    
    @objc func whenPush(_ sender : UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
    }
    
    @objc func whenSeparate(_ sender : UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
    }
}
