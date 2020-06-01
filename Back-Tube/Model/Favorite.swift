//
//  Favorite.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/31.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import RealmSwift

class Favorite : Object {
    
    @objc dynamic var id = 0
    @objc dynamic var videoId = ""
    @objc dynamic var title = ""
    @objc dynamic var thumbnailUrl = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
