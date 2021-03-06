//
//  SuggestWord.swift
//  Back-Tube
///Users/yuukisakai/Downloads/YoutubeAPI-master/YoutubuAPI/Modules/API/APIEndpoint.swift
//  Created by 酒井ゆうき on 2020/04/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

struct APIEndpoint {
    
    static func suggestWordUrl(suggestWord : String) -> String {
        
        let baseurl =  URL(string: "https://clients1.google.com/complete/search")!
        
        let queryItems = [URLQueryItem(name: "hl", value: "jp"),
               URLQueryItem(name: "ds", value: "yt"),
               URLQueryItem(name: "client", value: "firefox"),
                URLQueryItem(name: "q", value: "\(suggestWord)")]
        
        let viewCountUrl = baseurl.appending(queryItems)!
       
        return viewCountUrl.absoluteString
    }
}

struct APISearvice {
    static func suggestWordRequest(suggestWord : String, completion : @escaping([String], Error?) -> Void) {
        
//        let baseUrl = APIEndpoint.suggestWordUrl(suggestWord: suggestWord)
        let baseUrl = "https://clients1.google.com/complete/search?hl=jp&ds=yt&client=firefox&q=\(suggestWord)"
       
       
//        let decord = baseUrl.removingPercentEncoding
//        guard let url = URL(string: decord ?? "") else {return}
        guard let url = URL(string: baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {return}
//        guard let url = URL(string: baseUrl) else {return}
    
      
        let session = URLSession(configuration: .default)
        
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                completion([String](), error)
                return
            }
            
            guard let safedata = data else {return}
            do {
                
                var model = try JSONSerialization.jsonObject(with: safedata, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                model.remove(at: 0)
                let wordArray = model[0] as! [String]
                
                completion(wordArray, nil)
               
            } catch let error {
                
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
