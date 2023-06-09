//
//  Post.swift
//  Instegrem
//
//  Created by Bao Long on 03/06/2023.
//

import Foundation

struct Post {
    
    var idPost: String!
    var user: User!
    var postImage: PostImage
    var status: String = ""
    var time: Date!
    var uid: String = ""
    var numberOfLike: Int = 0
    var isLiked: Bool = false
    var numberOfComment: Int = 0
    
    init(idPost: String, user: User, dictionary: [String: Any]) {
        self.idPost = idPost
        let image = dictionary["image"] as? String ?? ""
        let ratio = dictionary["ratio"] as? Float ?? 0
        postImage = PostImage(image: image, ratio: CGFloat(ratio))
        self.status = dictionary["status"] as? String ?? ""
        if let time = dictionary["time"] as? Double {
            self.time = Date(timeIntervalSince1970: time)
        }
        self.user = user
    }
}

struct PostImage {
    var image: String
    var ratio: CGFloat
}
