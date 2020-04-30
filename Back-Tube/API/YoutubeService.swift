//
//  YoutubeService.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import YoutubeKit

struct YoutubeService {
    let searchWords : [String] = ["ラジオ","オールナイト","JUNK ラジオ"]
    
    static let shared = YoutubeService()
    
    func fetchTrend(completion:  @escaping([[SearchResult]], Error?) -> Void) {
        var results : [[SearchResult]] = [[],[],[]]
        for i in 0 ..< searchWords.count {
            
            searchRequest(searchWord: searchWords[i]) { (result, error) in
                
                if error != nil {
                    completion(results, error!)
                    return
                }
                
                results[i].append(contentsOf: result)
                completion(results,nil)
                
            }
            
        }
    }
    
    
    private func searchRequest(searchWord : String, completion : @escaping([SearchResult], Error?) -> Void) {
        
        let request = SearchListRequest(part: [.snippet], maxResults: 7, pageToken:  nil, searchQuery: searchWord,regionCode: "JP")
               
               YoutubeAPI.shared.send(request) { (result) in
                   switch result {
                   case .success(let response) :
                       
                       var results = [SearchResult]()
                       for result in response.items {
                           results.append(result)
                       }
                       
                       
                       completion(results, nil)
                       
                   case .failed(let error) :
                       completion([SearchResult](), error)
                   }
               }
        
    }
    
    
}
