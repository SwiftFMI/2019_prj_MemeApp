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
    
    private let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        emailAdress.center.x -= view.bounds.width
//        screenTitleLabel.center.x -= view.bounds.width
//        password.center.x -= view.bounds.width
//        username.center.x -= view.bounds.width
//        logControll.center.x -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
//            self.emailAdress.center.x += self.view.bounds.width
//            self.screenTitleLabel.center.x += self.view.bounds.width
//            self.password.center.x += self.view.bounds.width
//            self.username.center.x += self.view.bounds.width
//            self.logControll.center.x += self.view.bounds.width
//        }, completion: nil)
        
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
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
    
    private func setupBackground() {
        gradient.frame.size = view.frame.size
        gradient.startPoint = CGPoint(x: 1, y:1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.colors = [ #colorLiteral(red: 0.1426291466, green: 0.1426603794, blue: 0.1426250339, alpha: 1).cgColor , #colorLiteral(red: 0.235488981, green: 0.234095484, blue: 0.2365642488, alpha: 1).cgColor, #colorLiteral(red: 0.3131442964, green: 0.3145992458, blue: 0.3181353211, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        
    }
}
