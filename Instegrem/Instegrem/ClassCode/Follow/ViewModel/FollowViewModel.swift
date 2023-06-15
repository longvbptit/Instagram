//
//  FollowViewModel.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation

class FollowViewModel {
    
    func removeFollower(uid: String, completion: @escaping ((Bool) -> Void)) {
        UserService.removeFollower(uid: uid, completion: { error in
            if let error = error {
                completion(false)
                print(error.localizedDescription)
                return
            }
            completion(true)
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
