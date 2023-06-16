//
//  ExploreViewController-Extension-ColletionView.swift
//  Instegrem
//
//  Created by Bao Long on 16/06/2023.
//

import Foundation
import UIKit

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return isSearching ? dataCollection.0.count : 0
        } else {
            return !isSearching ? dataCollection.1.count : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
            cell.user = dataCollection.0[indexPath.row]
            cell.indexPath = indexPath
            cell.delegate = self
            cell.updateData()
            cell.updateFollowButton()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBottomCollectionViewCell", for: indexPath) as! ProfileBottomCollectionViewCell
            cell.image.sd_setImage(with: URL(string: dataCollection.1[indexPath.row].postImage.image))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = ProfileViewController()
            vc.isOrigin = false
            vc.user = dataCollection.0[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = DetailPostViewController()
            vc.posts = dataCollection.1
            vc.naviationBarTitle = "Explore"
            vc.indexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
