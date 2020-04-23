//
//  SearchReslutController.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class SearchResultController: UIViewController {
    var searchWord : String
    
    init(_searchWord : String) {
        self.searchWord = _searchWord
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        print(searchWord)
    }
}
