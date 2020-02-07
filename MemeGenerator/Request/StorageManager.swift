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
    
    func getTemplates(completion: @escaping () -> () ) {
        
        templatesRef.listAll { (result, error) in
            if let error = error {
                print(error)
            }
            var n = result.items.count
            for item in result.items {
                item.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        
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
    
    
    
}
