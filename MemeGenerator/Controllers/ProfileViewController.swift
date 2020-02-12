//
//  ProfileViewController.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 12.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 10
        
        guard let uid = UserDefaults.standard.string(forKey: "UID") else {
            return
        }
        FirebaseAuthManager.shared.setUserInfo(uid: uid, completion: {
            guard let user = FirebaseAuthManager.shared.currentUser else {
                return
            }
            self.usernameLabel.text = "user: \(user.username)"
        })
       
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        StorageManager.shared.images = []
        StorageManager.shared.searchedImages = []
        FirebaseAuthManager.shared.currentUser = nil
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(nil, forKey: "UID")
        UserDefaults.standard.synchronize()
        
        presentLoginViewController {
            self.navigationController?.viewControllers.removeFirst()
        }
        
        
    }
    
    func presentLoginViewController(completion: @escaping () -> () ) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(VC, animated: true)
        completion()
    }
    
}
