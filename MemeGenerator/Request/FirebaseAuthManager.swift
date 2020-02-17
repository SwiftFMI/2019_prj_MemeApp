//
//  AuthManager.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 4.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class FirebaseAuthManager: NSObject {
    
    static let shared = FirebaseAuthManager()
    
    let databaseRef = Database.database().reference()
    var currentUser: User?
    
    func login(email: String?, password: String? ,username: String?, completion: @escaping (_ success: Bool, _ error: Error?) -> () ){
        guard let email = email, !email.isEmpty else {
            completion(false, AuthError.noEmailAddress)
            return
        }
        guard let password = password, !password.isEmpty else {
            completion(false, AuthError.noPassword)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(false, error)
                return
            }
            guard let user = user else {
                completion(false, AuthError.noUser)
                return
            }
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(user.user.uid, forKey: "UID")
            self.currentUser = User(username: username ?? "" , uid: user.user.uid, profileImage: nil)
            UserDefaults.standard.synchronize()
            completion(true, nil)
        }
    }
    
    func singUp(email: String?, password: String? , username: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> () ) {
        guard let email = email, !email.isEmpty else {
            completion(false, AuthError.noEmailAddress)
            return
        }
        guard let password = password, !password.isEmpty else {
            completion(false, AuthError.noPassword)
            return
        }
        guard let username = username , !username.isEmpty else {
            completion(false, AuthError.noUsername)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user , error == nil else {
                completion(false, AuthError.noUser)
                return
            }
            
            self.currentUser = User(username: username, uid: user.user.uid)
            self.addUsertoDatabase(self.currentUser!)
            self.login(email: email, password: password, username: username) { (success, error) in
                completion(success,error)
            }
        }
    }
    
    func addUsertoDatabase(_ user: User) {
        
        let post = ["uid": user.uid,
                    "username":user.username,
                    "profileImage": (user.profileImage?.absoluteString) ?? "",
        ]
        databaseRef.child("users").child(user.uid).setValue(post)
    }
    
    func setUserInfo(uid: String, completion: @escaping () -> ()) {
        databaseRef.child("users").child("\(uid)").observeSingleEvent(of: .value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let profileImage = value?["profileImage"] as? String
            self.currentUser = User(username: username, uid: uid, profileImage: URL(string: profileImage ?? ""))
            completion()
        })
    }
    
    func changeProfileImage(url: URL, completion: ((_ success: Bool) -> ())? = nil) {
        guard let user = FirebaseAuthManager.shared.currentUser else {
            completion?(false)
            return
        }
        let post = ["uid": user.uid,
                    "username":user.username,
                    "profileImage": url.absoluteString,
        ]
        databaseRef.child("users").child(user.uid).setValue(post)
        FirebaseAuthManager.shared.currentUser?.profileImage = url
        completion?(true)
        
    }
}

enum AuthError: Error {
    case noEmailAddress
    case noUsername
    case noPassword
    case wrongFormattedEmail
    case wrongPassword
    case noUser
}


