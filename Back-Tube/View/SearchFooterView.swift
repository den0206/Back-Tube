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
        let attributeTitle =  (NSMutableAttributedString(string: "Show More", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor : UIColor.white]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowMore), for: .touchUpInside)
     
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
}
