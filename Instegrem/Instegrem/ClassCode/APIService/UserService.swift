//
//  UserService.swift
//  Instegrem
//
//  Created by Bao Long on 30/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class UserService {
    static let db = Firestore.firestore()
    
    public static func fetchUser() {
        
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
}

