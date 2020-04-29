//
//  TrendViewController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

private let resuseIdentifer = "TrendCell"
private let headerIdentifer = "SectionHeader"

class TrendViewController : UICollectionViewController {
    
    private  var videos = [Video]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var sectionTitles : [String] = ["All", "AllNight", "Junk"]

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureCV()
        fetchChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureCV() {
        
         view.backgroundColor = .black
        
        collectionView.register(TrendCell.self, forCellWithReuseIdentifier: resuseIdentifer)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
        
        collectionView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        
    }
    
    //MARK: - API
    
    private func fetchChart() {
          let request = VideoListRequest(part: [.id, .snippet], filter: .chart, maxResults: 10, regionCode: "JP" )
          
         
          
          // Send a request.
          YoutubeAPI.shared.send(request) { result in
              switch result {
              case .success(let response):
                  
                  var charts = [Video]()
                  for video in response.items {
                      charts.append(video)
      
                      self.videos = charts
                  }
              case .failed(let error):
                  print(error)
                  self.showErrorAlert(message: error.localizedDescription)
              }
          }
      }
    
}
extension TrendViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifer, for: indexPath) as! TrendCell
        
        cell.videos = videos
        return cell
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
         let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer, for: indexPath) as! SectionHeaderView
        
        if kind == UICollectionView.elementKindSectionHeader {
            header.sectionTitleLabel.text = sectionTitles[indexPath.section]
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
    }
    
}

extension TrendViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
