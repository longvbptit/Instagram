//
//  CommentViewModel.swift
//  Instegrem
//
//  Created by Bao Long on 15/06/2023.
//

import Foundation

class CommentViewModel {
    var user: User
    var comments: [Comment] = []
    var getCommentPostCompletion: (() -> Void)?
    var addCommentCompletion: (() -> Void)?
    
    init(user: User) {
        self.user = user
    }
    func getCommentPost(idPost: String) {
        HomeService.getCommentPost(idPost: idPost, completion: { [weak self] comments, error in
            if let error = error {
                self?.getCommentPostCompletion?()
                print(error.localizedDescription)
                return
            }
            self?.comments = comments.sorted { $0.time > $1.time }
            self?.getCommentPostCompletion?()
        })
    }
    
    func addComment(idPost: String, comment: String) {
        HomeService.addComment(idPost: idPost, comment: comment, completion: { [weak self] comment, time, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.addCommentCompletion?()
                print(error.localizedDescription)
                return
            }
            let newComment = Comment(user: strongSelf.user, time: time, comment: comment)
            strongSelf.comments.insert(newComment, at: 0)
            strongSelf.addCommentCompletion?()
        })
    }
}
