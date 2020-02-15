//
//  ViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 08/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailIdField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
//    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
//    NSUserDefaults.standardUserDefaults().synchronize()
//    let userDefaults = UserDefaults()
    
//    UserDefaults().standard.bool
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Signing in", message: nil, preferredStyle: .alert)
        
        
        
        present(alert, animated: true) {
            if let email = self.emailIdField.text,let password = self.passwordField.text
            {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        alert.dismiss(animated: true) {
                            print(e.localizedDescription)
                            let errorMessage = e.localizedDescription
                            let alert = UIAlertController(title: "Invalid Credintials", message: errorMessage, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style:.default, handler: nil))
                            self.present(alert,animated: true, completion: nil)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            alert.dismiss(animated: true) {
                                self.performSegue(withIdentifier: "SigninToTab", sender: self)
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func forgotButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
    }
}

