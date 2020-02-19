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
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var logControll: UISegmentedControl!
    
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var memeImage1: UIImageView!
    @IBOutlet weak var memeImage2: UIImageView!
    
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        emailAddress.attributedPlaceholder = NSAttributedString(string: "Email Adress", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.4)])
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.4)])
        username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.4)])
        
        logButton.backgroundColor = #colorLiteral(red: 0.6290653944, green: 0.6253284812, blue: 0.63193959, alpha: 1)
        logButton.layer.cornerRadius = 25
        setupBackground()
        
        emailAddress.center.x -= view.frame.width
        password.center.x -= view.frame.width
        screenTitleLabel.center.x -= view.frame.width
        logControll.center.x -= view.frame.width
        
        memeImage2.center.x -= 20
        memeImage1.center.x -= 20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImage1.alpha = 0
        memeImage2.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.screenTitleLabel.center.x += self.view.frame.width
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.emailAddress.center.x += self.view.frame.width
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.password.center.x += self.view.frame.width
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.logControll.center.x += self.view.frame.width
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.memeImage1.alpha = 0.6
            self.memeImage2.alpha = 0.6
            
            self.memeImage2.center.x += 20
            self.memeImage1.center.x += 20
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
        password.layer.borderWidth = 0
        emailAddress.layer.borderWidth = 0
        username.layer.borderWidth = 0
        
        if logControll.selectedSegmentIndex == 0 {
            username.isHidden = true
            clearTextField()
            screenTitleLabel.text = "Login"
            
            password.alpha = 0
            emailAddress.alpha = 0
            screenTitleLabel.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.password.alpha = 1
                self.emailAddress.alpha = 1
                self.screenTitleLabel.alpha = 1
            })
            
        } else {
            username.isHidden = false
            clearTextField()
            screenTitleLabel.text = "Sing up"
            
            password.alpha = 0
            emailAddress.alpha = 0
            username.alpha = 0
            screenTitleLabel.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.password.alpha = 1
                self.emailAddress.alpha = 1
                self.username.alpha = 1
                self.screenTitleLabel.alpha = 1
            })
            
        }
    }
    
    @IBAction func logButtonPressed(_ sender: Any) {
        
        indicator.frame = logButton.frame
        indicator.startAnimating()
        indicator.style = .large
        self.view.addSubview(indicator)
        password.layer.borderWidth = 0
        emailAddress.layer.borderWidth = 0
        username.layer.borderWidth = 0
        emailAddress.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        if logControll.selectedSegmentIndex == 0 {
            FirebaseAuthManager.shared.login(email: emailAddress.text, password: password.text, username: "" , completion: {success,error in
                if success {
                    StorageManager.shared.getTemplates {
                        StorageManager.shared.getUsersTemplates {
                            self.presentMainTabBarController(completion: {
                                self.navigationController?.viewControllers.removeFirst()
                            })
                        }
                    }
                } else {
                    self.errorLabel.isHidden = false
                    self.indicator.stopAnimating()
                    if (error as? AuthError) == nil {
                        self.errorLabel.text = error?.localizedDescription
                        self.emailAddress.layer.borderWidth = 2
                        self.emailAddress.layer.borderColor = UIColor.red.cgColor
                        self.emailAddress.layer.cornerRadius = 10
                        self.password.layer.borderWidth = 2
                        self.password.layer.borderColor = UIColor.red.cgColor
                        self.password.layer.cornerRadius = 10
                        return
                    }
                    self.errorHandle(error as! AuthError)
                }
            })
        } else {
            FirebaseAuthManager.shared.singUp(email: emailAddress.text, password: password.text, username: username.text, completion: { success , error in
                if success {
                    self.presentMainTabBarController(completion: {
                        self.navigationController?.viewControllers.removeFirst()
                    })
                } else {
                    self.errorLabel.isHidden = false
                    self.indicator.stopAnimating()
                    if (error as? AuthError) == nil {
                        self.errorLabel.text = error?.localizedDescription
                        self.emailAddress.layer.borderWidth = 2
                        self.emailAddress.layer.borderColor = UIColor.red.cgColor
                        self.emailAddress.layer.cornerRadius = 10
                        self.password.layer.borderWidth = 2
                        self.password.layer.borderColor = UIColor.red.cgColor
                        self.password.layer.cornerRadius = 10
                        self.username.layer.borderWidth = 2
                        self.username.layer.borderColor = UIColor.red.cgColor
                        self.username.layer.cornerRadius = 10
                        
                        return
                    }
                    self.errorHandle(error as! AuthError)
                }
                
            })
        }
    }
    
    func errorHandle(_ error: AuthError ) {
        switch  error {
        case .noEmailAddress:
            self.errorLabel.text = "Please enter your email adress"
            self.emailAddress.layer.borderColor = UIColor.red.cgColor
            self.emailAddress.layer.borderWidth = 1
            self.emailAddress.layer.cornerRadius = 10
            
        case .noPassword:
            self.errorLabel.text = "Please enter your password"
            self.password.layer.borderColor = UIColor.red.cgColor
            self.password.layer.borderWidth = 1
            self.password.layer.cornerRadius = 10
            
        case .noUsername:
            self.errorLabel.text = "Please enter your username"
            self.username.layer.borderColor = UIColor.red.cgColor
            self.username.layer.borderWidth = 1
            self.username.layer.cornerRadius = 10
        case .noUser:
            self.errorLabel.text = "The email or password is incorrect"
            
        default:
            return
        }
    }
    
    func presentMainTabBarController(completion: @escaping () -> () ) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        self.navigationController?.pushViewController(VC, animated: true)
        completion()
    }
    
    private func clearTextField() {
        emailAddress.text = ""
        password.text = ""
        username.text = ""
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
    
    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.frame.size = view.frame.size
        gradient.startPoint = CGPoint(x: 1, y:1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.colors = [ #colorLiteral(red: 0.1426291466, green: 0.1426603794, blue: 0.1426250339, alpha: 1).cgColor , #colorLiteral(red: 0.235488981, green: 0.234095484, blue: 0.2365642488, alpha: 1).cgColor, #colorLiteral(red: 0.3131442964, green: 0.3145992458, blue: 0.3181353211, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
}
