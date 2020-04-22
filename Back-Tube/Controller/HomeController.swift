//
//  HomeController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit

private let reuseIdentifer = "VideoCell"

class HomeController: UICollectionViewController{
    
    //MARK: - Vars
    
    private  var videos = [Video]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureUI()
        
        fetchChart()
      
    }
    
 
    
    private func configureNav() {
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearence.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        
        
        navigationItem.title = "Home"
    }
    
    private func configureUI() {
        
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.scrollDirection = .horizontal
//            flowLayout.minimumLineSpacing = 0
//        }
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        
        
        
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
            }
        }
    }
    
}

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! VideoCell
        
        cell.video = videos[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let video = videos[indexPath.item]
        
        
        let viewoLauncher = VideoLauncher(videoId: video.id)
        present(viewoLauncher, animated: true, completion: nil)
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (view.frame.width - 16 - 16) * 9 / 16
        
        return CGSize(width: view.frame.width, height: height + 16 + 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
