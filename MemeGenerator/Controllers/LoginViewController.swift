//
//  LoginViewController.swift
//  MemeGenerator
//
//  Created by Ralitsa Dobreva on 4.02.20.
//  Copyright © 2020 Ralitsa Dobreva. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var logControll: UISegmentedControl!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.isHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func logControllChanged(_ sender: Any) {
        if logControll.selectedSegmentIndex == 0 {
            username.isHidden = true
            clearTextField()
            screenTitleLabel.text = "Login"
        } else {
            username.isHidden = false
            clearTextField()
            screenTitleLabel.text = "Sing up"
        }
    }
    
    @IBAction func logButtonPressed(_ sender: Any) {
        if logControll.selectedSegmentIndex == 0 {
            FirebaseAuthManager.shared.login(email: emailAdress.text, password: password.text, completion: {success,error in
                if success {
                    
                } else {
                    self.errorLabel.text = error?.localizedDescription
                    self.errorLabel.isHidden = false
                }
            })
        } else {
            FirebaseAuthManager.shared.singUp(email: emailAdress.text, password: password.text, username: username.text, completion: { success , error in
                if success {
                    
                } else {
                    self.errorLabel.text = error?.localizedDescription
                    self.errorLabel.isHidden = false
                }
                
            })
        }
    }
    
    private func clearTextField() {
        emailAdress.text = ""
        password.text = ""
        username.text = ""
    }
}
