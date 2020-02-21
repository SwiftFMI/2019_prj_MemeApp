//
//  MainTabBarController.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 7.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import Foundation
import  UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        guard let uid = UserDefaults.standard.string(forKey: "UID") else {
            return
        }
        
        FirebaseAuthManager.shared.setUserInfo(uid: uid,completion: {
        })
        
    }
}
