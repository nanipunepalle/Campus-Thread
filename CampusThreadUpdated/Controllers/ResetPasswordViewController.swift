//
//  ResetPasswordViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 10/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (err) in
                if err != nil{
                    
                    //alert message for error
                    let alert = UIAlertController(title: "Invalid email", message: "Enter valid email address", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style:.default, handler: nil))
                    self.present(alert,animated: true, completion: nil)
                }
                else{
                    
                    //alert message for verification of email
                    
                    let alert = UIAlertController(title: "Success", message: "Check your email and continue with login", preferredStyle: .alert)
                    alert .addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert,animated: true, completion: nil)
                    self.emailTextField.text = ""
                }
            }
        }
    }
}
