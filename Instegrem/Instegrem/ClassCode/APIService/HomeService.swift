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
            for document in querySnapshot!.documents {
                let data = document.data()
                UserService.getUser(uid: data["uid"] as! String, completion: { dataUser, err in
                    if let error = err {
                        completion([], error)
                        return
                    }
                    let user = User(uid: dataUser["uid"] as! String, dictionary: dataUser)
                    let post = Post(user: user, dictionary: data)
                    posts.append(post)
                    countData += 1
                    if countData == querySnapshot!.documents.count {
                        posts = posts.sorted { $0.time > $1.time }
                        completion(posts, nil)
                    }
                })
            }
        })
    }
}
