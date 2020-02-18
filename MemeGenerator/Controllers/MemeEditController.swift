//
//  MemeEditController.swift
//  MemeGenerator
//
//  Created by Viktoria Guncheva on 17.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIDropInteractionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        ]
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.isHidden = true
        bottomTextField.isHidden = true
        
        func stylizeTextField(textField: UITextField) {
            textField.defaultTextAttributes = memeTextAttributes

            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            textField.textAlignment = .center
            textField.delegate = self
        }
        
        stylizeTextField(textField: topTextField)
        stylizeTextField(textField: bottomTextField)
        
        // hide keyboard on tab outside the text field
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // *** Add text to meme *** //
    
    // top and bottom text field will show
    @IBAction func addTextAction(_ sender: Any) {
        topTextField.isHidden = !topTextField.isHidden
        bottomTextField.isHidden = !bottomTextField.isHidden
        
        // listen for keyboard events
        subscribeToKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if topTextField.text == "TOP" {
            topTextField.isHidden = true
        }
        if bottomTextField.text == "BOTTOM" {
            bottomTextField.isHidden = true
        }
        
        let memedImage = generateMemedImage()
        // save to Library and in Firebase
        saveMemeToLibrary(memedImage: memedImage)
        saveMemeInFirebase(memedImage: memedImage)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        if topTextField.text == "TOP" {
            topTextField.isHidden = true
        }
        if bottomTextField.text == "BOTTOM" {
            bottomTextField.isHidden = true
        }
        
        let memedImage = generateMemedImage()
        
        shareInFacebook(memedImage: memedImage)
    }
    
    // *** get photo from album/camera to meme *** //
    
    @IBAction func libraryButtonAction(_ sender: Any) {
        pickAnImageFromSource(source: .photoLibrary)
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        pickAnImageFromSource(source: .camera)
    }
    
    
    @IBAction func closeEditAction(_ sender: Any) {
    }
    
}
