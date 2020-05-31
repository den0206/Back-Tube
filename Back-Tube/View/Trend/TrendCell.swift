//
//  TrendCell.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import YoutubeKit
import RealmSwift

protocol TrendCellDelegate {
    
    func didScrollCell(cell : TrendCell, indexPath : IndexPath)
    func didTappedRadio(title : String)
    
    func presentAlert(alert : UIAlertController)
}


private let resuseIdentifer = "SubCell"
private let resuseAddIdentifer = "addCell"
private let reuseWordIdentifer = "WordCell"

class TrendCell : UICollectionViewCell {
    
    var delegate : TrendCellDelegate?
    
    var cellType : TrendCellType?
    
    var stickyWords = [String]() {
        didSet {
            if cellType == .week
            {
                
                collectionView.reloadData()
            }
        }
    }
    
    var favoriteVideos : Results<Favorite>? {
        didSet {
        }
    }
    
    let userDefaults = UserDefaults.standard

    /// Uiimage Arrays
    
    //MARK: - Vars
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
        collectionView.register(addCell.self, forCellWithReuseIdentifier: resuseAddIdentifer)
        collectionView.register(WordCell.self, forCellWithReuseIdentifier: reuseWordIdentifer)
        
        
        collectionView.anchor(top : topAnchor,left : leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
//        userDefaults.removeObject(forKey: "stickyWords")
        
        stickyWords = getSticktyWords()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension TrendCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if cellType == .week {
            if !stickyWords.isEmpty {
                return 2

            }
        }
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if cellType == .week {
            
            switch section {
            case 0:
                return 1
            case 1 :
                return stickyWords.count
            default:
                return 0
            }
        } else if cellType == .favorite {
            return favoriteVideos!.count
        }
        
    

        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifer, for: indexPath) as! PlayListCell
        
        let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseAddIdentifer, for: indexPath) as! addCell
        let wordCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseWordIdentifer, for: indexPath) as! WordCell
        
        guard let celltype = cellType else {return cell}
 
        switch celltype {
        case .week :
            
            switch indexPath.section {
            case 0:
                return addCell
            case 1 :
                wordCell.word = stickyWords[indexPath.item]
                wordCell.stickyLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.height).isActive = true
                
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
                wordCell.addGestureRecognizer(longPressGesture)
                return wordCell
            default:
                return addCell
            }
            
        case .allnight:
            cell.radio = allnights[indexPath.row]
        case .junk :
            cell.radio = junks[indexPath.item]

        case .favorite:
            cell.favorite = favoriteVideos![indexPath.item]
        }
        
        
        
        return cell
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didScrollCell(cell: self, indexPath: indexPath)
        
        var radio : Radio?
        var word : String?
        
        switch cellType {
            
        case .week :
            switch indexPath.section {
            case 0:
                addStiockyWord(indexPath: indexPath)
                return
            case 1 :
                word = stickyWords[indexPath.item]
                
                guard let word = word else {return}
                delegate?.didTappedRadio(title: word)
                
                return
            default:
                return
            }
            

        case .allnight :
            radio = allnights[indexPath.item]

        case .junk :
            radio = junks[indexPath.item]
        default :
            return


        }

        guard let searchTitle = radio?.title else {return}
        
        delegate?.didTappedRadio(title: searchTitle)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
   
}

extension UICollectionView {
    func nowPosition(cell : UICollectionViewCell) -> CGRect {
        let point = CGPoint(x: cell.frame.origin.x - self.contentOffset.x, y: cell.frame.origin.y - self.contentOffset.y)
        let size = cell.bounds.size
        
        return CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
    }
    
    
    
}

//MARK: - Generate Sticky Words

extension TrendCell {
    
    //MARK: - Alert
    
    private func addStiockyWord(indexPath : IndexPath) {
        var alertTextField : UITextField?
        
        let alert = UIAlertController(title: "お気に入りを登録", message: "検索する文字を追加できます", preferredStyle: .alert)
        alert.addTextField { (textField) in
            alertTextField = textField
            textField.placeholder = "Search Word"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            if let text = alertTextField?.text{
                self.addStickyWords(text: text)
            }
        }))
        
        delegate?.presentAlert(alert: alert)
        
    }
    
    private func getSticktyWords() -> [String] {
        
        if let words = userDefaults.array(forKey: "stickyWords") as? [String] {
            return words
        }
        
        return [String]()
    }
    
    //MARK: - add user Default
    
    private func addStickyWords(text : String) {
        
        guard text != "" else {return}
        
        stickyWords = getSticktyWords()
        
        for word in stickyWords {
            if word == text {
                return
            }
        }
        
        if stickyWords.count == 6 {
            stickyWords.removeLast()
        }
        
        stickyWords.insert(text, at: 0)
        userDefaults.set(stickyWords, forKey: "stickyWords")
        
        
    }
    
    //MARK: - Delete
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: collectionView)
            if let index = collectionView.indexPathForItem(at: touchPoint) {
                deleteAlert(index: index)

            }
        }
    }
    
    private func deleteAlert(index : IndexPath) {
        let wotd = stickyWords[index.item]
        
        let alert = UIAlertController(title: "Delete", message: "\(wotd)を削除しても宜しいでしょうか？", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.collectionView.deleteItems(at: [index])
            self.stickyWords.remove(at: index.row)
            self.userDefaults.set(self.stickyWords, forKey: "stickyWords")
            
        }))
        
        delegate?.presentAlert(alert: alert)
    }
    
    
}

