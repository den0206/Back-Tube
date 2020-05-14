//
//  PopupViewController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

protocol PopViewControllerDelegate {
    func relatedVideo(videoId : String, title : String)
}

enum SearchType {
    case searchWord
    case playRelate
}


class PopupViewController : UIViewController {
    
    var searchWord : String?
    var videoId : String?
    
    var searchType : SearchType
    
    var delegate : PopViewControllerDelegate?
    
    init(searchType : SearchType) {
        self.searchType = searchType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

    //MARK: - parts
    
    let popView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let okButton : UIButton = {
        let button = UIButton()
        button.setTitle("再生", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(checkOk), for: .touchUpInside)
        return button
    }()
    
    private let noButton : UIButton = {
        let button = UIButton()
        button.setTitle("戻る", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleDisimiss), for: .touchUpInside)
        return button
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePopup()
        
    }
    
    private func configurePopup() {
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height
        
//        let popupWidth = (screenWidth * 3)/4
//        let popupHeight = (screenWidth * 4)/5
        
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.view.tag = 1
        
        
        /// tap backGround
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDisimiss))
        self.view.addGestureRecognizer(tap)

        
        popView.frame = CGRect(x: screenWidth / 8, y: screenHeight / 5, width: 300, height: 300)
        self.view.addSubview(popView)
        
        /// banner 3
         AdMobHelper.shared.mediumBannerAd(adBaseView: popView, rootVC: self, bannerId: AdMobID.bannerViewTest.rawValue)
        
        

        let stack = UIStackView(arrangedSubviews: [okButton,noButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center

        popView.addSubview(stack)

        stack.anchor(left :popView.leftAnchor,bottom: popView.bottomAnchor,right: popView.rightAnchor,height: 50)
       
       
        
        
        
    }

    //MARK: - Actions
    
    @objc func checkOk() {
    
        
        switch searchType {
        case .searchWord:
            print("Search")

            guard let searchWord = searchWord, let videoId = videoId else {
                self.view.removeFromSuperview()
                return}
            
            self.tabBarController?.showPresentLoadindView(true)
            
            let playingVC = tabBarController?.viewControllers![2] as! PlayingViewController
            self.tabBarController?.selectedIndex = 2
            
            self.view.removeFromSuperview()
            
            
            playingVC.videoId = videoId
            playingVC.relatedTitle = searchWord
            
        case .playRelate :
            print("RELATE")
            
            guard let searchWord = searchWord, let videoId = videoId else {
            self.view.removeFromSuperview()
            return}
            
            self.view.removeFromSuperview()
            
            
            delegate?.relatedVideo(videoId: videoId, title: searchWord)
            
        }
        
       
    }
    
    @objc func handleDisimiss() {
        self.view.removeFromSuperview()
    }
    
}
