//
//  ProfileViewController.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 12.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var changeUsernameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 10
        usernameTextField.isHidden = true
        setupBackground()
        
        if let uid = UserDefaults.standard.string(forKey: "UID") {
            FirebaseAuthManager.shared.setUserInfo(uid: uid) {
                guard let user = FirebaseAuthManager.shared.currentUser else {
                    return
                }
                let attrString = NSMutableAttributedString(string: "username: \(user.username) ", attributes: [
                    .font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!,
                    .foregroundColor: UIColor.black,
                    .kern: -0.09
                ])
                attrString.addAttributes([
                    .font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!,
                    .foregroundColor: UIColor.black
                ], range: NSRange(location: 0, length: 8))
                self.usernameLabel.attributedText = attrString
                
                self.profileImage.kf.setImage(with: user.profileImage, for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logoutButton.center.x -= 50
        stack.center.x -= 50
        profileImage.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleLabel.alpha = 0
        UIView.transition(with: titleLabel, duration: 0.7, options: [.transitionFlipFromLeft], animations: {
            self.titleLabel.alpha = 1
            self.profileImage.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.stack.center.x += 50
            self.logoutButton.center.x += 50
        }, completion: nil)
      
    }
    
    @IBAction func changeUsernameButtonPressed(_ sender: Any) {
        usernameTextField.isHidden = false
        usernameTextField.text = ""
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        StorageManager.shared.images = []
        StorageManager.shared.searchedImages = []
        FirebaseAuthManager.shared.currentUser = nil
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(nil, forKey: "UID")
        UserDefaults.standard.synchronize()
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogNavigation") 
        UIApplication.shared.keyWindowInScene?.rootViewController = vc
        UIApplication.shared.keyWindowInScene?.makeKeyAndVisible()
        
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.frame.size = view.frame.size
        gradient.startPoint = CGPoint(x: 1, y:1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.colors = [ #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1).cgColor , #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor, #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let alert  = UIAlertController(title:  "Choose your image ", message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard  let imageURL = info[.imageURL] as? NSURL else {
            return
        }
        
        StorageManager.shared.changeProfileImage(url: imageURL as URL , completion: {
            success in
            
            if success {
                guard let user = FirebaseAuthManager.shared.currentUser, let imageURLPath = user.profileImage else {
                    return
                }
                FirebaseAuthManager.shared.changeProfileImage(url: imageURLPath, completion: nil)
                self.profileImage.kf.setImage(with: imageURLPath, for: .normal)
            }
        })
        picker.dismiss(animated: true)
    }

}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        usernameTextField.isHidden = true
        guard let username = usernameTextField.text else {
            usernameLabel.text = "username"
            return
        }
        usernameLabel.text = username
        FirebaseAuthManager.shared.changeUsername(newUsername: username)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
