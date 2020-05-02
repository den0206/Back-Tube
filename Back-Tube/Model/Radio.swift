//
//  Allnight.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/02.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit

class Radio {
    let title : String
       let thumbnailImage : UIImage
       
       init(title : String, thumbnailImage : UIImage) {
           self.title = title
           self.thumbnailImage = thumbnailImage
       }
}

class Allnight : Radio{

}

let allnights : [Allnight] = [
    Allnight(title: "菅田", thumbnailImage: UIImage(named: "allnight-mon")!),
    Allnight(title: "星野源", thumbnailImage: UIImage(named:"allnight-tue")!),
    Allnight(title: "乃木坂46", thumbnailImage:  UIImage(named: "allnight-wed")!),
    Allnight(title: "岡村隆史", thumbnailImage:  UIImage(named: "allnight-thu")!),
    Allnight(title: "三四郎", thumbnailImage:  UIImage(named: "allnight-fry")!),
    Allnight(title: "オードリー ", thumbnailImage:   UIImage(named: "allnight-sat")!)
]

let allnightArray : [UIImage] = [UIImage(named: "allnight-mon")!,
                                 UIImage(named: "allnight-tue")!,
                                 UIImage(named: "allnight-wed")!,
                                 UIImage(named: "allnight-thu")!,
                                 UIImage(named: "allnight-fry")!,
                                 UIImage(named: "allnight-sat")!]

class Junk  : Radio{
}

let junks : [Junk] = [
    Junk(title: "伊集院", thumbnailImage: UIImage(named: "junk-mon")!),
    Junk(title: "爆笑問題", thumbnailImage: UIImage(named:"junk-tue")!),
    Junk(title: "山里亮太", thumbnailImage:  UIImage(named: "junk-wed")!),
    Junk(title: "おぎやはぎ", thumbnailImage:  UIImage(named: "junk-thu")!),
    Junk(title: "バナナマン", thumbnailImage:  UIImage(named: "junk-fry")!),
    Junk(title: "エレ片のコント太郎", thumbnailImage:   UIImage(named: "junk-sat")!)
]

//MARK: - Weekly Array

let weekleArray : [String] = [
    "月",
    "火",
    "水",
    "木",
    "金",
    "土"
]


