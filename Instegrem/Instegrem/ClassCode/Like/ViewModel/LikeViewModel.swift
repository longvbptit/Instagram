//
//  LikeViewModel.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation

class LikeViewModel {
    
    var users: [User] = []
    var getUserLikePostCompletion: (() -> Void)?
    
    func getUserLikePost(idPost: String) {
        HomeService.getUsersLikedPost(idPost: idPost, completion: { [weak self] users, error in
            if let error = error {
                self?.getUserLikePostCompletion?()
                print(error.localizedDescription)
                return
            }
            self?.users = users
            self?.getUserLikePostCompletion?()
        })
    }
    
    func followUser(uid: String, completion: @escaping ((Bool) -> Void)) {
        UserService.followUser(uid: uid, completion: { error in
            if let error = error {
                completion(false)
                print(error.localizedDescription)
                return
            }
            completion(true)
        })
    }
    
    func unFollowUser(uid: String, completion: @escaping ((Bool) -> Void)) {
        UserService.unfollowUser(uid: uid, completion: { error in
            if let error = error {
                completion(false)
                print(error.localizedDescription)
                return
            }
            completion(true)
        })
    }
}
