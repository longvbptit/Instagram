//
//  Comment.swift
//  Instegrem
//
//  Created by Bao Long on 08/06/2023.
//

import Foundation

struct Comment {
    var user: User!
    var time: Date!
    var comment: String = ""
    
    init(user: User, arr: [Any]) {
        self.user = user
//        let arr = dictionary.first?.value as? [Any]
        self.comment = arr[2] as? String ?? ""
        if let time = arr[1] as? Double {
            self.time = Date(timeIntervalSince1970: time)
        }
    }
    
    init(user: User, time: Double, comment: String) {
        self.user = user
        self.time = Date(timeIntervalSince1970: time)
        self.comment = comment
    }
}
