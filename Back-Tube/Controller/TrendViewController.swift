//
//  TrendViewController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit
import RealmSwift

private let resuseIdentifer = "TrendCell"
private let headerIdentifer = "SectionHeader"

enum TrendCellType {
    case week
    case allnight
    case junk
    case favorite
}

class TrendViewController : UICollectionViewController {

    
    lazy var sectionTitles : [String] =  {
        if favotiteVideos.count > 0 {
           return ["Favorite", "AllNight", "Junk", "Favorite"]
        }
        
        return ["Favorite", "AllNight", "Junk"]
    }()
    
    var favotiteVideos : Results<Favorite>!

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureCV()
        
        checkFavorite()
//        fetchTrends()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        

    }
    
    private func configureCV() {
        
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        collectionView.register(TrendCell.self, forCellWithReuseIdentifier: resuseIdentifer)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
        
        collectionView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 100, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 25, left: 0, bottom: 100, right: 0)
        
    }
    
    private func  checkFavorite() {
        let realm = try! Realm()
        
        
        favotiteVideos = realm.objects(Favorite.self).sorted(byKeyPath: "id", ascending: false)
        
    
//
//        if favotiteVideos.count > 0 {
//            sectionTitles.append("Favorite")
//
//        }
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)

    }

    //MARK: - Youtibe API
    
//    private func fetchTrends() {
//        YoutubeService.shared.fetchTrend { (results, error) in
//
//            if error != nil {
//                self.showErrorAlert(message: error!.localizedDescription)
//            }
//            self.resultArrays = results
//            print(self.resultArrays.count)
//        }
//    }


}
extension TrendViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitles.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifer, for: indexPath) as! TrendCell
        
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            cell.cellType = .week
        case 1 :
            cell.cellType = .allnight
        case 2:
            cell.cellType = .junk
        case 3 :
            cell.cellType = .favorite
            cell.favoriteVideos = favotiteVideos
        default:
            cell.cellType = .none
        }
        
//        if resultArrays.count == 3 {
//            cell.videos = resultArrays[indexPath.section]
//        }
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
        
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 150)
        }
        
        return CGSize(width: view.frame.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
       
        return 50
    }
}

//MARK: - TrendCell Delegate

extension TrendViewController : TrendCellDelegate {

    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
   
    func didScrollCell(cell: TrendCell, indexPath: IndexPath) {
        cell.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        
    }
    
    func didTappedRadio(title: String) {
        
        self.tabBarController?.showPresentLoadindView(true)
        let resultVC = SearchResultController(_searchWord: title)
        navigationController?.pushViewController(resultVC, animated: true)
    }
    


}



extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

