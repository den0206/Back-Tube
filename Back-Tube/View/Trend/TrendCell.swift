//
//  TrendCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit


private let resuseIdentifer = "SubCell"

class TrendCell : UICollectionViewCell {
    
    //MARK: - Vars
    
    var videos = [SearchResult]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var arrays = [[SearchResult]]()
    /// cell.video = arrays[indexPath.section]
    //MARK: - Parts
//

    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// add subCV
        
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlayListCell.self, forCellWithReuseIdentifier: resuseIdentifer)
        collectionView.anchor(top : topAnchor,left : leftAnchor,bottom: bottomAnchor,right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrendCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        switch arrays[section] {
//        default:
//           return arrays[section].count
//        }
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifer, for: indexPath) as! PlayListCell
        
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height, height: frame.height)
    }
    
    
}
