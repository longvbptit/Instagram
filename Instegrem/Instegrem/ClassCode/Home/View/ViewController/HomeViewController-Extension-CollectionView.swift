//
//  HomeViewController-Extension-CollectionView.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation
import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .story:
            return 10
        case .post:
            return dataHome.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .story:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorySavedCollectionViewCell", for: indexPath) as! StorySavedCollectionViewCell
            if indexPath.row == 0 {
                cell.addStoryImage.isHidden = false
                cell.storyImage.sd_setImage(with: URL(string: user.avatar), placeholderImage: UIImage(named: "ic-avatar_default"))
            } else {
                cell.storyImage.image = UIImage(named: story[indexPath.row].image)
                cell.addStoryImage.isHidden = true
            }
            
            cell.storyImage.cornerRadius = 32
            cell.widthAddStory.constant = 64/3
            cell.storyLabel.text = story[indexPath.row].title
            cell.storyImage.contentMode = .scaleAspectFill
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
            cell.indexPath = indexPath
            cell.post = dataHome[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
    
}
