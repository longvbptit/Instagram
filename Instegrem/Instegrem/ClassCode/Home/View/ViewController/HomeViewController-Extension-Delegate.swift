//
//  HomeViewController-Extension.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation
import FirebaseAuth

extension HomeViewController: PostDelegate {
    func gotoComment(indexPath: IndexPath) {
        let vc = CommentViewController()
        vc.post = dataHome[indexPath.row]
        vc.indexPath = indexPath
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLike(indexPath: IndexPath) {
        let vc = LikeViewController()
        vc.idPost = dataHome[indexPath.row].idPost
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoProfile(user: User) {
        let vc = ProfileViewController()
        vc.isOrigin = false
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func likePost(indexPath: IndexPath, isLike: Bool, numberOfLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if isLike {
            viewModel.likePost(idPost: dataHome[indexPath.row].idPost, uid: uid)
        } else {
            viewModel.unLikePost(idPost: dataHome[indexPath.row].idPost, uid: uid)
        }
        dataHome[indexPath.row].isLiked = isLike
        dataHome[indexPath.row].numberOfLike = numberOfLike
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }

}

extension HomeViewController: CommentPostDelegate {
    func updateNumberOfCommentButton(indexPath: IndexPath, numberOfComment: Int) {
        dataHome[indexPath.row].numberOfComment = numberOfComment
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }
}

