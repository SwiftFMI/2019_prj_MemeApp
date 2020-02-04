//
//  AuthManager.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 4.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager: NSObject {
    
    static let shared = FirebaseAuthManager()
    var currentUser: User?
    
    func login(email: String?, password: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> () ){
        guard let email = email, let password = password else {
            completion(false, nil)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(false, error)
                return
            }
            guard let _ = user else {
                completion(false, AuthError.noUser)
                return
            }
            
            UserDefaults.standard.set(true, forKey: "isLoged")
            UserDefaults.standard.synchronize()
            
            completion(true, nil)
        }
    }
    
    func singUp(email: String?, password: String? , username: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> () ) {
        guard let email = email, let password = password, let username = username else {
            completion(false, AuthError.missingInfo)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user , error == nil else {
                completion(false, AuthError.missingInfo)
                return
            }
            
            self.currentUser = User(username: username, uid: user.user.providerID)
            self.login(email: email, password: password) { (success, error) in
                completion(success,error)
            }
            
        }
        
    }
    
    
}

enum AuthError: Error {
    case missingInfo
    case noUser
}


