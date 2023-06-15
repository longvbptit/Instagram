//
//  ExploreViewModel.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation

class ExploreViewModel {
    
    var fetchPostCompletion: (() -> Void)?
    var fetchUserCompletion: (() -> Void)?
    var dataPosts: [Post] = []
    var dataUsers: [User] = []
    func fetchAllPost() {
        HomeService.fetchPost(completion: { [weak self] data, error in
            if error != nil {
                self?.dataPosts = []
                self?.fetchPostCompletion?()
            }
            self?.dataPosts = data
            self?.fetchPostCompletion?()
        })
    }
    
    func fetchUserByName(key: String) {
        UserService.fetchUserByName(key: key, completion: { [weak self] users, error in
            if error != nil {
                self?.dataUsers = []
                self?.fetchUserCompletion?()
            }
            self?.dataUsers = users
            self?.fetchUserCompletion?()
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


