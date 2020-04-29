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
    
    var resultArrays = [[SearchResult]]() {
        didSet {
            if resultArrays.count == 3 {
                print(resultArrays.count)
                collectionView.reloadData()
            }
        }
    }
    
//    private  var videos = [SearchResult]() {
//        didSet {
////            print(videos)
//            collectionView.reloadData()
//        }
//    }
//
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
        
        YoutubeService.shared.fetchTrend { (results, error) in

            if error != nil {
                self.showErrorAlert(message: error!.localizedDescription)
            }
            self.resultArrays = results
            print(self.resultArrays.count)
        }
//        fetchRadio()
//        fetchAllnight()
//        fetchJunk()
        
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
    
    private func fetchRadio() {
        
        let request = SearchListRequest(part: [.snippet], maxResults: 7, pageToken:  nil, searchQuery: "ラジオ",regionCode: "JP")
        
        YoutubeAPI.shared.send(request) { (result) in
            switch result {
            case .success(let response) :
                
                var results = [SearchResult]()
                for result in response.items {
                    results.append(result)
                }
             
//                self.videos = results
//                self.resultArrays.append(results)
                self.resultArrays.insert(results, at: 0)
                
             
            case .failed(let error) :
                print(error)
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    private func fetchAllnight() {
        
        let request = SearchListRequest(part: [.snippet], maxResults: 7, pageToken:  nil, searchQuery: "オールナイト",regionCode: "JP")
        
        YoutubeAPI.shared.send(request) { (result) in
            switch result {
            case .success(let response) :
                
                var results = [SearchResult]()
                for result in response.items {
                    results.append(result)
                }
                
                self.resultArrays.insert(results, at: 1)
                
                
                
            case .failed(let error) :
                print(error)
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    private func fetchJunk() {
        
        let request = SearchListRequest(part: [.snippet], maxResults: 7, pageToken:  nil, searchQuery: "JUNK ラジオ",regionCode: "JP")
        
        YoutubeAPI.shared.send(request) { (result) in
            switch result {
            case .success(let response) :
                
                var results = [SearchResult]()
                for result in response.items {
                    results.append(result)
                }
                
                //                self.videos = results
                self.resultArrays.append(results)
                
            case .failed(let error) :
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
        
        cell.delegate = self
        if resultArrays.count == 3 {
            cell.videos = resultArrays[indexPath.section]
        }
//
       
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

extension TrendViewController : TrendCellDelegate {
    
    func didTappedTrend(video: SearchResult) {
        guard let videoId = video.id.videoID else {return}
        
        let launcher = VideoLauncher(videoId: videoId)
        self.present(launcher, animated: true, completion: nil)
     
    }
    
    
}
