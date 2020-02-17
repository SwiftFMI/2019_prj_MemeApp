//
//  FirebaseStorageManager.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 7.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import Foundation
import  UIKit
import FirebaseStorage


final class StorageManager: NSObject {
    
    static let shared = StorageManager()
    private let storageRef = Storage.storage().reference()
    private var templatesRef = Storage.storage().reference().child("Templates")
    
    var images: [String] = []
    var searchedImages: [String] = []
    
    func getTemplates(completion: @escaping () -> () ) {
        
        templatesRef.listAll { (result, error) in
            if let error = error {
                print(error)
            }
            var n = result.items.count
            for item in result.items {
                item.downloadURL { url, error in
                    if let error = error {
                        print(error)
                        
                    } else {
                        guard let url = url else {
                            return
                        }
                        self.images.append(url.absoluteString)
                        n -= 1
                        if n == 0 {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func getUsersTemplates(completion: @escaping () -> () ) {
        
        guard let user = UserDefaults.standard.string(forKey: "UID") else {
            return
        }
        
        templatesRef.child("\(user)").listAll { (result, error) in
            
            if let error = error {
                print(error)
            }
            var n = result.items.count
            for item in result.items {
                item.downloadURL { url, error in
                    if let error = error {
                        print(error)
                        
                    } else {
                        guard let url = url else {
                            return
                        }
                        self.images.append(url.absoluteString)
                        n -= 1
                        if n == 0 {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func uploadTemplates( url: URL?, complition: @escaping (_ success: Bool) -> ()) {
        
        uploadImage(refPath: "Templates/", url: url, complition: {
            success, url  in
            if success {
                guard let url = url , let _ = UserDefaults.standard.string(forKey: "UID") else {
                    complition(false)
                    return
                    
                }
                self.images.append(url.absoluteString)
            }
            complition(false)
        })
    }
    
    func changeProfileImage(url: URL, completion: @escaping (_ success: Bool) -> ()) {
        
        if let uid = FirebaseAuthManager.shared.currentUser?.uid ,let url = FirebaseAuthManager.shared.currentUser?.profileImage {
            let desertRef = storageRef.child("ProfileImages/\(uid)").child(url.lastPathComponent)
            desertRef.delete { error in
                if let error = error {
                    print(error)
                }
            }
        }
        
        self.uploadImage(refPath: "ProfileImages", url: url, complition: {
            success, urlPath in
            if success {
                guard let _ = FirebaseAuthManager.shared.currentUser else {
                    completion(false)
                    return
                }
                
                FirebaseAuthManager.shared.currentUser?.profileImage = urlPath
                completion(true)
                return
            }
            completion(false)
        })
        
    }
    
    private func uploadImage(refPath: String, url: URL?, complition: @escaping (_ success: Bool,_ url: URL?) -> ()) {
        guard let url = url , let uid = UserDefaults.standard.string(forKey: "UID") else {
            complition(false,nil)
            return
        }
        let imageRef = storageRef.child(refPath).child(uid).child(url.lastPathComponent)
        imageRef.putFile(from: url, metadata: nil, completion: { metadata, error in
            if let error = error  {
                print(error)
                complition(false,nil)
                return
            }
            guard let _ = metadata else {
                complition(false,nil)
                return
            }
            
            imageRef.downloadURL(completion: { url , error in
                if let error = error  {
                    print(error)
                    complition(false,nil)
                    return
                }
                guard let url = url else {
                    complition(false,nil)
                    return
                }
                complition(true, url)
            })
        })
    }
    
    func searchTemplates(_ word: String ) {
        searchedImages = images.filter({
            $0.contains(word)
        })
    }
    
    
}
