//
//  HomeViewModel.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation

class HomeViewModel {
    var dataHome: [Post] = []
    var completion: (() -> Void)?
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
}
