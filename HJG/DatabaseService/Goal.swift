//
//  Goal.swift
//  HJG
//
//  Created by Suzy Park on 2018. 5. 25..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import Foundation

class Goal {
   
    var postID: String!
    var title: String!
    var content: String!
    var date: Date!
    
    init(postID: String, dic: [String:Any]) {
        
        self.postID = postID
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        if let title = dic["title"] as? String,
            let content = dic["content"] as? String,
            let dateStr = dic["date"] as? String,
            let date = formatter.date(from: dateStr) {
            
            self.title = title
            self.content = content
            self.date = date
        }
    }
}
