//
//  UserService.swift
//  Instegrem
//
//  Created by Bao Long on 30/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
class UserService {
    static let db = Firestore.firestore()
    
    public static func fetchUserByName(key: String, completion: @escaping ([User], Error?) -> Void) {
        db.collection("users").getDocuments(completion: { documentSnap, error in
                if let error = error {
                    completion([],error)
                    return
                }
                var users: [User] = []
                guard let listDocs = documentSnap?.documents else {
                    completion([],error)
                    return
                }
                guard let currentUID = Auth.auth().currentUser?.uid else { return }
                if listDocs.isEmpty { completion([], nil); return }
                for doc in listDocs {
                    var user = User(uid: doc.documentID, dictionary: doc.data())
                    if user.uid != currentUID {
                        UserService.checkFollowedByCurrenUser(uid: user.uid, completion: { isFollowed, error in
                            user.isFollowByCurrentUser = isFollowed ? .followed : .notFollowYet
                            users.append(user)
                            if users.count == listDocs.count {
                                if key == "" {
                                    completion(users, nil)
                                    return
                                } else {
                                    let searchUser = users.filter({ user in
                                        user.userName.lowercased().contains(key.lowercased())
                                    })
                                    completion(searchUser, nil)
                                    return
                                }
                            }
                        })
                    } else {
                        users.append(user)
                        if users.count == listDocs.count {
                            if key == "" {
                                completion(users, nil)
                                return
                            } else {
                                let searchUser = users.filter({ user in
                                    user.userName.lowercased().contains(key.lowercased())
                                })
                                completion(searchUser, nil)
                                return
                            }
                        }
                    }
                }
            })
    }
    
    public static func updateUser(user: User, avatar: UIImage?, completion: @escaping (Error?) -> Void) {
        
        guard let avatar = avatar else {
            self.updateUserInfo(user: user) {error in
                completion(error)
            }
            return
        }
        
        guard let imageData = avatar.jpegData(compressionQuality: 0.3) else {return}
        
        let fileID = NSUUID().uuidString
        let ref = Storage.storage().reference().child(fileID)
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                completion(error)
            }
            
            ref.downloadURL { url, _ in
                guard let profileImageUrl = url?.absoluteString else {
                    self.updateUserInfo(user: user) { error in
                        completion(error)
                    }
                    return
                }
                
                self.updateUserInfo(user: user, imageURL: profileImageUrl) { error in
                    completion(error)
                }
            }
        }
    }
    
    public static func updateUserInfo(user: User, imageURL: String? = nil, completion: @escaping (Error?) -> Void) {
        let dictionary: [String: Any]
        
        if let imageURL = imageURL  {
            dictionary = ["avatar": imageURL,
                          "name": user.name,
                          "username": user.userName,
                          "bio": user.bio]
        } else {
            dictionary = ["name": user.name,
                          "username": user.userName,
                          "bio": user.bio]
        }
        
        db.collection("users").document(user.uid).setData(dictionary, merge: true) { error in
            completion(error)
        }
    }
    
    static public func getUser(uid: String, completion: @escaping ([String: Any],Error?) -> Void) {
        db.collection("users").document(uid).getDocument(completion: { documentSnap, error in
            if let error = error {
                completion([:],error)
                return
            }
            guard let data = documentSnap?.data() else {
                completion([:],error)
                return
            }
            completion(data, nil)
        })
    }
    
    static public func followUser(uid: String, completion: @escaping (Error?) -> Void) {
        guard let currenUID = Auth.auth().currentUser?.uid else { return }
        db.collection("followers").document(uid).setData([currenUID: 1], merge: true) { err in
            if let error = err {
                completion(error)
            }
        }
        db.collection("following").document(currenUID).setData([uid: 1], merge: true) { err in
            if let error = err {
                completion(error)
            }
        }
        completion(nil)
    }
    
    static public func unfollowUser(uid: String, completion: @escaping (Error?) -> Void) {
        guard let currenUID = Auth.auth().currentUser?.uid else { return }
        db.collection("followers").document(uid).updateData([currenUID: FieldValue.delete()]) { err in
            if let error = err {
                completion(error)
            }
        }
        db.collection("following").document(currenUID).updateData([uid: FieldValue.delete()]) { err in
            if let error = err {
                completion(error)
            }
        }
        completion(nil)
    }
    
    static public func removeFollower(uid: String, completion: @escaping (Error?) -> Void) {
        guard let currenUID = Auth.auth().currentUser?.uid else { return }
        db.collection("following").document(uid).updateData([currenUID: FieldValue.delete()]) { err in
            completion(err)
        }
        db.collection("followers").document(currenUID).updateData([uid: FieldValue.delete()]) { err in
            completion(err)
        }
    }
    
    static public func checkFollowedByCurrenUser(uid: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        db.collection("following").document(currentUID).getDocument(completion: { doc, error in
            if let error = error {
                completion(false, error)
                return
            }
            if doc?.data()?[uid] is Int {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
            
        })
    }
    
    static public func getAllFolowers(uid: String, completion: @escaping ([User], Error?) -> Void) {
        db.collection("followers").document(uid).getDocument(completion: { data, error in
            if let error = error {
                completion([],error)
                return
            }
            guard let data = data?.data() else {
                completion([], error)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            var users: [User] = []
            if data.isEmpty { completion([], nil); return }
            for (idUser, _) in data {
                UserService.getUser(uid: idUser, completion: { dataUser, err in
                    if let error = err {
                        completion([], error)
                        return
                    }
                    var user = User(uid: idUser, dictionary: dataUser)
                    if user.uid != uid {
                        UserService.checkFollowedByCurrenUser(uid: user.uid, completion: { isFollowed, error in
                            user.isFollowByCurrentUser = isFollowed ? .followed : .notFollowYet
                            users.append(user)
                            if users.count == data.count {
                                completion(users, nil)
                            }
                        })
                    } else {
                        users.append(user)
                        if users.count == data.count {
                            completion(users, nil)
                        }
                    }
                })
            }
        })
    }
    
    static public func getAllFolowing(uid: String, completion: @escaping ([User], Error?) -> Void) {
        db.collection("following").document(uid).getDocument(completion: { data, error in
            if let error = error {
                completion([],error)
                return
            }
            guard let data = data?.data() else {
                completion([], error)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            var users: [User] = []
            if data.isEmpty { completion([], nil); return }
            for (idUser, _) in data {
                UserService.getUser(uid: idUser, completion: { dataUser, err in
                    if let error = err {
                        completion([], error)
                        return
                    }
                    var user = User(uid: idUser, dictionary: dataUser)
                    if user.uid != uid {
                        UserService.checkFollowedByCurrenUser(uid: user.uid, completion: { isFollowed, error in
                            user.isFollowByCurrentUser = isFollowed ? .followed : .notFollowYet
                            users.append(user)
                            if users.count == data.count {
                                completion(users, nil)
                            }
                        })
                    } else {
                        users.append(user)
                        if users.count == data.count {
                            completion(users, nil)
                        }
                    }
                })
            }
        })
    }
}

