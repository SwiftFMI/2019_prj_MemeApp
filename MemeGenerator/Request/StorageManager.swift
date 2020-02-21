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
    private var memesRef = Storage.storage().reference().child("Memes")
    
    var images: [String] = []
    var searchedImages: [String] = []
    var memes: [String] = []
    
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
    
    func getMemes(completion: @escaping () -> ()) {
        
        memesRef.listAll { (result, error) in
            
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
                        self.memes.append(url.absoluteString)
                        n -= 1
                        if n == 0 {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func uploadImage(url: URL?, complition: @escaping (_ success: Bool) -> ()) {
        guard let url = url , let uid = UserDefaults.standard.string(forKey: "UID") else {
            complition(false)
            return
        }
        let imageRef = templatesRef.child(uid).child("\(url.lastPathComponent)")
        imageRef.putFile(from: url, metadata: nil, completion: { metadata, error in
            if let error = error  {
                print(error)
                complition(false)
                return
            }
            guard let _ = metadata else {
                complition(false)
                return
            }
            
            imageRef.downloadURL(completion: { url , error in
                if let error = error  {
                    print(error)
                    complition(false)
                    return
                }
                guard let url = url else {
                    complition(false)
                    return
                }
                self.images.append(url.absoluteString)
                complition(true)
            })
        })
        
    }
    
    func searchTemplates(_ word: String ) {
        searchedImages = images.filter({
            $0.contains(word)
        })
    }
    
    
}
