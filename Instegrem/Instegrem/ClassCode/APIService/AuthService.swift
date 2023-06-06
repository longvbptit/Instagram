//
//  AuthService.swift
//  Instegrem
//
//  Created by Bao Long on 30/05/2023.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore
import SDWebImage

struct CreateAccountInfo {
    var email = ""
    var password = ""
    var userName = ""
    var name = ""
}

class AuthService {
    
    static let db = Firestore.firestore()
    
    public static func createAccount(info: CreateAccountInfo, completion: @escaping(Error?) -> Void) {
        Auth.auth().createUser(withEmail: info.email, password: info.password) { authResult, error in
            if let error = error {
                completion(error)
                return
            }
            guard let authResult = authResult else { return }
            let data = ["uid": authResult.user.uid
                        ,"username": info.userName,
                        "name": info.name ]
            db.collection("users").document("\(String(describing: authResult.user.uid))").setData(data, completion: completion)
            
        }
    }
    
    public static func logOut() {
        do {
            try Auth.auth().signOut()
            SDImageCache.shared.clearMemory()
        } catch {
            print("DEBUG: Cannot LogOut")
        }
    }
    
}
