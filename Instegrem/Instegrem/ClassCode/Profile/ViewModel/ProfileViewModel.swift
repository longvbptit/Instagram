//
//  ProfileViewModel.swift
//  Instegrem
//
//  Created by Bao Long on 31/05/2023.
//

import Foundation

class ProfileViewModel {
    var user: User!
    var getUserCompletion: (() -> Void)?
    var followers: [User] = []
    var getFollowersCompletion: (() -> Void)?
    var following: [User] = []
    var getFollowingCompletion: (() -> Void)?
    var posts: [Post] = []
    var getPostCompletion: (() -> Void)?
    func getFollowers() {
        UserService.getAllFolowers(uid: user.uid, completion: { [weak self] followers, error in
            if let error = error {
                self?.getFollowersCompletion?()
                print(error.localizedDescription)
                return
            }
            self?.followers = followers
            self?.getFollowersCompletion?()
        })
    }
    
    func getFollowing() {
        UserService.getAllFolowing(uid: user.uid, completion: { [weak self] following, error in
            if let error = error {
                self?.getFollowingCompletion?()
                print(error.localizedDescription)
                return
            }
            self?.following = following
            self?.getFollowingCompletion?()
        })
    }
    
    func fetchUserPost() {
        HomeService.fetchUserPosts(user: user, completion: { [weak self] data, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.getPostCompletion?()
                print("Cant get posts. Error: \(error)")
                return
            }
            strongSelf.posts = data
            strongSelf.getPostCompletion?()
        })
    }
    
    func getUser() {
        UserService.getUser(uid: user.uid, completion: { [weak self] dataUser, err in
            if err != nil {
                self?.getUserCompletion?()
                return
            }
            self?.user = User(uid: dataUser["uid"] as! String, dictionary: dataUser)
            self?.getUserCompletion?()
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
