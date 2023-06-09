//
//  User.swift
//  Instegrem
//
//  Created by Bao Long on 29/05/2023.
//

import Foundation


struct User {
    var uid: String
    var userName: String = ""
    var name: String = ""
    var bio: String = ""
    var avatar: String = ""
    var isFollowByCurrentUser: FollowingState = .currenUser
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.userName = dictionary["username"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.avatar = dictionary["avatar"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
    }
    
}

enum FollowingState {
    case currenUser
    case notFollowYet
    case followed
}
