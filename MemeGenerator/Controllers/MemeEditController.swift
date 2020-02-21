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
    @IBOutlet weak var fontButton: UIButton!
    @IBOutlet var allFontButtons: [UIButton]!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navBar: UITabBarItem!
    
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
        
        fontButton.isHidden = true
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
        bottomTextField.isHidden = topTextField.isHidden
        fontButton.isHidden = topTextField.isHidden
        
        // listen for keyboard events
        subscribeToKeyboardNotifications()
    }
    
    @IBAction func changeFont(_ sender: Any) {
        allFontButtons.forEach{ (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Fonts: String {
        case f1 = "F1"
        case f2 = "F2"
        case f3 = "F3"
        case f4 = "F4"
        case f5 = "F5"
    }
    
    @IBAction func chooseFont(_ sender: UIButton) {
        guard let title = sender.currentTitle, let font = Fonts(rawValue: title) else {
            return
        }
        
        switch font {
        case .f1:
            topTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            bottomTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        case .f2:
            topTextField.font = UIFont(name: "Copperplate", size: 40)
            bottomTextField.font = UIFont(name: "Copperplate", size: 40)
        case .f3:
            topTextField.font = UIFont(name: "GillSans-Italic", size: 40)
            bottomTextField.font = UIFont(name: "GillSans-Italic", size: 40)
        case .f4:
            topTextField.font = UIFont(name: "MarkerFelt-Wide", size: 40)
            bottomTextField.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        case .f5:
            topTextField.font = UIFont(name: "TamilSangamMN-Bold", size: 40)
            bottomTextField.font = UIFont(name: "TamilSangamMN-Bold", size: 40)
        }
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
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
}
