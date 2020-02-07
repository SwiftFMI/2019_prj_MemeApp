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
    
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupBackground()
        emailAdress.center.x -= view.frame.width
        password.center.x -= view.frame.width
        screenTitleLabel.center.x -= view.frame.width
        logControll.center.x -= view.frame.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.screenTitleLabel.center.x += self.view.frame.width
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.emailAdress.center.x += self.view.frame.width
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.password.center.x += self.view.frame.width
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.logControll.center.x += self.view.frame.width
        }, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        logButton.layer.add(animation, forKey: nil)
        
    }
    
    @IBAction func logControllChanged(_ sender: Any) {
        if logControll.selectedSegmentIndex == 0 {
            username.isHidden = true
            clearTextField()
            screenTitleLabel.text = "Login"

            
            password.alpha = 0
            emailAdress.alpha = 0
            screenTitleLabel.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.password.alpha = 1
                self.emailAdress.alpha = 1
                self.screenTitleLabel.alpha = 1
            })
            
        } else {
            username.isHidden = false
            clearTextField()
            screenTitleLabel.text = "Sing up"
            
            password.alpha = 0
            emailAdress.alpha = 0
            username.alpha = 0
            screenTitleLabel.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.password.alpha = 1
                self.emailAdress.alpha = 1
                self.username.alpha = 1
                self.screenTitleLabel.alpha = 1
            })
            
        }
    }
    
    @IBAction func logButtonPressed(_ sender: Any) {
        if logControll.selectedSegmentIndex == 0 {
            FirebaseAuthManager.shared.login(email: emailAdress.text, password: password.text, completion: {success,error in
                if success {
                    self.presentMainTabBarController(completion: {
                        self.navigationController?.viewControllers.removeFirst()
                    })
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
    
    func presentMainTabBarController(completion: @escaping () -> () ) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        self.navigationController?.pushViewController(VC, animated: true)
        completion()
        
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
