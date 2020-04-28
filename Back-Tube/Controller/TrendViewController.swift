//
//  TrendViewController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let resuseIdentifer = "TrendCell"

class TrendViewController : UICollectionViewController {
    

    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        configureCV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureCV() {
        
         view.backgroundColor = .black
        
        
        collectionView.register(TrendCell.self, forCellWithReuseIdentifier: resuseIdentifer)
        
    }
    
}
extension TrendViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifer, for: indexPath) as! TrendCell
    
        return cell
    }
    
    
}

extension TrendViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
