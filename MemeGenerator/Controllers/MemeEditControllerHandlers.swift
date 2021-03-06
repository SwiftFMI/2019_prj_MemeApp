//
//  MemeEditControllerHandlers.swift
//  MemeGenerator
//
//  Created by Viktoria Guncheva on 17.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FirebaseStorage

extension MemeEditViewController {

    // *** handle keyboard events *** //
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return pressed")
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        // move the screen if keyboard shown for bottom text field
        if bottomTextField.isFirstResponder {
            print("Keyboard change")
            if bottomTextField.text == "BOTTOM" {
                bottomTextField.text = ""
            }
            guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                view.frame.origin.y = -keyboardRect.height
            } else {
                view.frame.origin.y = 0
            }
        }
        
        if topTextField.isFirstResponder && topTextField.text == "TOP" {
            topTextField.text = ""
        }
    }
    
    func showHideAppIcons() {
        exitButton.isHidden = !exitButton.isHidden
        textButton.isHidden = !textButton.isHidden
        shareButton.isHidden = !shareButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        photoLibraryButton.isHidden = !photoLibraryButton.isHidden
        cameraButton.isHidden = !cameraButton.isHidden
        fontButton.isHidden = !fontButton.isHidden
    }
    
    // *** pick image *** //
    
    func pickAnImageFromSource(source: UIImagePickerController.SourceType) {
        //Code To Pick An Image From Source
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = source
            present(pickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Problem accessing the camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // show image on screen, when selected
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // hide app icons
        showHideAppIcons()
        
        // Render View To An Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show app icons again
        showHideAppIcons()

        return memedImage
    }
    
    func saveMemeToLibrary(memedImage: UIImage) {
        let imageData = memedImage.pngData()
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Meme has been saved!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveMemeInFirebase(memedImage: UIImage) {
        let uid = UserDefaults.standard.string(forKey: "UID")
        let storageRef = Storage.storage().reference()
        let memeRef = storageRef.child("Memes/\(NSUUID().uuidString).png")
        print("Memes/\(uid!)/\(NSUUID().uuidString).png")
        
        let imageData = memedImage.pngData()
        let _ = memeRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
            print(error as Any)
                return
            }}
    }
    
    func shareInFacebook(memedImage: UIImage) {
        let alert = UIAlertController(title: "Share", message: "Share your meme!", preferredStyle: .actionSheet)
        
        let fbAction = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            let photo: SharePhoto = SharePhoto()
            photo.image = memedImage
            photo.isUserGenerated = true
            
            let content: SharePhotoContent = SharePhotoContent()
            content.photos = [photo]
            
            let shareDialog = ShareDialog(fromViewController: self, content: content, delegate: nil)
            shareDialog.mode = .native
            shareDialog.shouldFailOnDataError = true
            
            shareDialog.show()
        }
        
        
        alert.addAction(fbAction)
        self.present(alert, animated: true, completion: nil)
    }
}
