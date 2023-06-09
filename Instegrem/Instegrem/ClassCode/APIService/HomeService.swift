//
//  HomeService.swift
//  Instegrem
//
//  Created by Bao Long on 03/06/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class HomeService {
    static let db = Firestore.firestore()
    
    public static func upLoadPost(status: String, postImage: UIImage, completion: @escaping (Error?) -> Void) {
        guard let imageData = postImage.jpegData(compressionQuality: 0.3) else { return }
        
        let fileID = NSUUID().uuidString
        let ref = Storage.storage().reference().child(fileID)
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                completion(error)
            }
            
            ref.downloadURL { url, _ in
                guard let dataImageUrl = url?.absoluteString else { return }
                let time = Int(NSDate().timeIntervalSince1970)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let dictionary = ["image": dataImageUrl,
                                  "status": status,
                                  "time": time,
                                  "ratio": Float(postImage.size.width) / Float(postImage.size.height),
                                  "uid": uid]
                db.collection("post").document().setData(dictionary, merge: true) { error in
                    completion(error)
                }
            }
        }
    }
    
    public static func fetchPost(completion: @escaping ([Post], Error?) -> Void) {
        db.collection("post").getDocuments(completion: { querySnapshot, err in
            if let error = err {
                completion([],error)
                return
            }
            var posts: [Post] = []
            var countData = 0
            guard let querySnapshot = querySnapshot else { completion([], nil); return}
            for document in querySnapshot.documents {
                let data = document.data()
                UserService.getUser(uid: data["uid"] as! String, completion: { dataUser, err in
                    if let error = err {
                        completion([], error)
                        return
                    }
                    let user = User(uid: dataUser["uid"] as! String, dictionary: dataUser)
                    HomeService.getNumberLikePost(idPost: document.documentID, completion: { numberOfLike, isLiked, err in
                        
                        HomeService.getNumberOfComment(idPost: document.documentID, completion: { numberOfComment, err in
                            var post = Post(idPost:document.documentID, user: user, dictionary: document.data())
                            post.numberOfLike = numberOfLike
                            post.isLiked = isLiked
                            post.numberOfComment = numberOfComment
                            posts.append(post)
                            countData += 1
                            if countData == querySnapshot.documents.count {
                                posts = posts.sorted { $0.time > $1.time }
                                completion(posts, nil)
                            }
                        })
                        
                    })
                })
            }
        })
    }
    
    public static func fetchUserPosts(user: User, completion: @escaping([Post], Error?) -> Void) {
        db.collection("post").whereField("uid", isEqualTo: user.uid).getDocuments(completion: { querySnapshot, err in
            if let error = err {
                completion([],error)
                return
            }
            var posts: [Post] = []
            var countData = 0
            guard let querySnapshot = querySnapshot else { completion([], nil); return}
            for document in querySnapshot.documents {
                //                let post = Post(idPost:document.documentID, user: user, dictionary: document.data())
                //                posts.append(post)
                //                countData += 1
                //                if countData == querySnapshot.documents.count {
                //                    posts = posts.sorted { $0.time > $1.time }
                //                    completion(posts, nil)
                //                }
                //
                HomeService.getNumberLikePost(idPost: document.documentID, completion: { numberOfLike, isLiked, err in
                    
                    HomeService.getNumberOfComment(idPost: document.documentID, completion: { numberOfComment, err in
                        var post = Post(idPost:document.documentID, user: user, dictionary: document.data())
                        post.numberOfLike = numberOfLike
                        post.isLiked = isLiked
                        post.numberOfComment = numberOfComment
                        posts.append(post)
                        countData += 1
                        if countData == querySnapshot.documents.count {
                            posts = posts.sorted { $0.time > $1.time }
                            completion(posts, nil)
                        }
                    })
                    
                })
            }
        })
    }
    
    public static func likeStatus(idPost: String, uid: String, completion: @escaping (Error?) -> Void) {
        let dict: [String: Any] = [uid: 1]
        db.collection("like").document(idPost).setData(dict, merge: true) { error in
            completion(error)
        }
    }
    
    public static func unLikeStatus(idPost: String, uid: String, completion: @escaping (Error?) -> Void) {
        db.collection("like").document(idPost).updateData([uid: FieldValue.delete()]) { err in
            completion(err)
        }
    }
    
    public static func getNumberLikePost(idPost: String, completion: @escaping (Int, Bool, Error?) -> Void) {
        db.collection("like").document(idPost).getDocument(completion: { data, error in
            if let error = error {
                completion(0, false,error)
                return
            }
            guard let data = data?.data() else {
                completion(0, false, error)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            if data[uid] != nil {
                completion(data.count, true, nil)
            } else {
                completion(data.count, false, nil)
            }
            
        })
    }
    
    public static func getUsersLikedPost(idPost: String, completion: @escaping ([User], Error?) -> Void) {
        db.collection("like").document(idPost).getDocument(completion: { data, error in
            if let error = error {
                completion([],error)
                return
            }
            guard let data = data?.data() else {
                completion([], error)
                return
            }
            //            guard let uid = Auth.auth().currentUser?.uid else { return }
            var countUser = 0
            var users: [User] = []
            for (idUser, _) in data {
                UserService.getUser(uid: idUser, completion: { dataUser, err in
                    if let error = err {
                        completion([], error)
                        return
                    }
                    countUser += 1
                    let user = User(uid: idUser, dictionary: dataUser)
                    users.append(user)
                    if countUser == data.count {
                        completion(users, nil)
                    }
                })
            }
        })
    }
    
    public static func getNumberOfComment(idPost: String, completion: @escaping (Int, Error?) -> Void) {
        db.collection("comment").document(idPost).getDocument(completion: { data, error in
            if let error = error {
                completion(0, error)
                return
            }
            completion(data?.data()?.count ?? 0, nil)
        })
    }
    
    public static func getCommentPost(idPost: String, completion: @escaping ([Comment], Error?) -> Void) {
        db.collection("comment").document(idPost).getDocument(completion: { data, error in
            if let error = error {
                completion([], error)
                return
            }
            guard let data = data?.data() else {
                completion([], error)
                return
            }
            var countComment = 0
            var comments: [Comment] = []
            for (_, dataComment) in data {
                guard let arr = dataComment as? [Any] else { return }
                let uid = arr[0] as? String ?? ""
                UserService.getUser(uid: uid, completion: { dataUser, err in
                    if let error = err {
                        completion([], error)
                        return
                    }
                    countComment += 1
                    let user = User(uid: uid, dictionary: dataUser)
                    let comment = Comment(user: user, arr: arr)
                    comments.append(comment)
                    if countComment == data.count {
                        completion(comments, nil)
                    }
                })
            }
        })
    }
    
    public static func addComment(idPost: String, comment: String, completion: @escaping (String, Double, Error?) -> Void) {
        let time = Int(NSDate().timeIntervalSince1970)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let dict: [String: Any] = ["\(uid)\(time)": [uid,
                                                     Int(time),
                                                     comment]]
        db.collection("comment").document(idPost).setData(dict, merge: true) { error in
            completion(comment, Double(time), error)
        }
    }
    
}
