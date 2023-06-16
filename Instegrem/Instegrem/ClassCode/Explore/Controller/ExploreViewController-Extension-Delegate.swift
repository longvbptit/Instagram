//
//  ExploreViewController-Extension-Delegate.swift
//  Instegrem
//
//  Created by Bao Long on 16/06/2023.
//

import Foundation
import UIKit

extension ExploreViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(handleTimer(_:)), userInfo: searchText, repeats: false)
        
    }
    
    @objc private func handleTimer(_ sender: Timer) {
        guard timer?.isValid == true else {
            return
        }
        if let searchText = sender.userInfo as? String {
            searchUserbyName(key: searchText)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.dataCollection = (self.users, [])
        self.collectionView.reloadData()
        if !isSearching {
            searchUserbyName(key: "")
        }
        isSearching = true
        UIView.animate(withDuration: 0.3, animations: {
            self.cancelButtonLeftAnchor.constant = -40
            self.view.layoutIfNeeded()
        })
        return true
    }
}

extension ExploreViewController: FollowUserDelegate {
    func followUser(uid: String, indexPath: IndexPath) {
        if users[indexPath.row].isFollowByCurrentUser == .notFollowYet {
            viewModel.followUser(uid: uid, completion: { [weak self] result in
                if !result { return }
                self?.users[indexPath.row].isFollowByCurrentUser = .followed
                self?.dataCollection.0 = self?.users ?? []
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
            })
        } else {
            viewModel.unFollowUser(uid: uid, completion: { [weak self] result in
                if !result { return }
                self?.users[indexPath.row].isFollowByCurrentUser = .notFollowYet
                self?.dataCollection.0 = self?.users ?? []
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
            })
        }
    }
}
