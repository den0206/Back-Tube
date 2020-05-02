//
//  TrendCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

protocol TrendCellDelegate {
    func didTappedTrend(video : SearchResult)
    func didScrollCell(indexPath : IndexPath)
}


private let resuseIdentifer = "SubCell"
private let resuseWeeklyIdentifer = "WeeklyCell"

class TrendCell : UICollectionViewCell {
    
    var delegate : TrendCellDelegate?
    
    var cellType : TrendCellType?
    /// Uiimage Arrays
    
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
        collectionView.register(WeeklyCell.self, forCellWithReuseIdentifier: resuseWeeklyIdentifer)
        
        collectionView.anchor(top : topAnchor,left : leftAnchor,bottom: bottomAnchor,right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrendCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifer, for: indexPath) as! PlayListCell
        
        let weeklyCell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseWeeklyIdentifer, for: indexPath) as! WeeklyCell
        
        guard let celltype = cellType else {return cell}
 
        switch celltype {
        case .week :
            weeklyCell.weekLabel.text = weekleArray[indexPath.item]

            return weeklyCell
        case .allnight:
            cell.radio = allnights[indexPath.row]
        case .junk :
            cell.radio = junks[indexPath.item]

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var radio : Radio?
        switch cellType {
        case .week :
            
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
//            delegate?.didScrollCell(indexPath: indexPath)
           
        case .allnight :
            radio = allnights[indexPath.item]
        case .junk :
            radio = junks[indexPath.item]
        case .none:
            return
        }
        
        guard let searchTitle = radio?.title else {return}
        print(searchTitle)
        
    }
    
    
}
