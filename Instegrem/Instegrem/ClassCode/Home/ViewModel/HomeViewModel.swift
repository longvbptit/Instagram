//
//  HomeViewModel.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation
import UIKit

class HomeViewModel {
    var dataHome: [Post] = []
    var completion: (() -> Void)?
    var uploadPostCompletion: ((Bool) -> Void)?
    func fetchHomePost(user: User) {
        HomeService.fetchFollowingPost(user: user, completion: { [weak self] data, error in
            if error != nil {
                self?.dataHome = []
                self?.completion?()
            }
            self?.dataHome = data
            self?.completion?()
        })
    }
    
    func likePost(idPost: String, uid: String) {
        HomeService.likeStatus(idPost: idPost, uid: uid, completion: { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        })
    }
    
    func unLikePost(idPost: String, uid: String) {
        HomeService.unLikeStatus(idPost: idPost, uid: uid, completion: { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        })
    }

    func uploadPost(status: String, image: UIImage) {
        HomeService.upLoadPost(status: status,
                               postImage: image,
                               completion: { [weak self] error in
            guard let strongSelf = self else { return }
            if error != nil {
                strongSelf.uploadPostCompletion?(false)
                return
            }
            strongSelf.uploadPostCompletion?(true)
            
        })
    }
}
