//
//  SignUpViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 10/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import  FirebaseAuth
class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    let Colleges = ["","VIT University","GITAM University"]
    let YouAre = ["","Student","Faculty","Club/Organization"]
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailidTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var youAreTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        universityPicker()
        youArePicker()
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //Regular expression for strong password
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //Validating fields in the form
    
    func validateFields() -> String?{
        if fullnameTextField.text == "" || emailidTextField.text == "" || passwordTextField.text == "" || universityTextField.text == "" || youAreTextField.text == "" {
            return  "Please fill in all fields"
        }
        let email = emailidTextField.text!.lowercased()
        if isValidEmail(email) == false
        {
            return "Invalid Email"
        }
        let updatedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(updatedPassword) == false{
            return "Password must have 8 characters with atleast one Alphabet and one Number"
        }
        
        return nil
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Signing up", message: nil, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "Dismiss", style:.default, handler: nil))
        //        self.present(alert,animated: true, completion: nil)
        self.present(alert, animated: true) {
            let error = self.validateFields()
            
            if error != nil{
                alert.dismiss(animated: true) {
                    self.showAlert(err: self.validateFields()!)
                }
            }
                
                
            else{
                
                let fullName = self.fullnameTextField.text!
                let email = self.emailidTextField.text!
                let password = self.passwordTextField.text!
                let college = self.universityTextField.text!
                let youAre = self.youAreTextField.text!
                let url = "https://firebasestorage.googleapis.com/v0/b/updated-campus-thread.appspot.com/o/ProfilePicimages%2Fycr4pHcC2sU4uJ2z97Ncsejyzob2.jpg?alt=media&token=466ce0b9-4dde-404d-8c0b-1ef8e1033e22"
                Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                    if(err != nil)
                    {
                        print(err ?? "error in signin page")
                        alert.dismiss(animated: true) {
                            self.showAlert(err: err!.localizedDescription)
                        }
                        
                    }
                    else
                    {
                        let ref = self.db.collection("users").document()
                        let docid = ref.documentID
                        ref.setData(["FullName":fullName,"Emailid":email,"College":college,"HeIs":youAre,"Uid":result!.user.uid,"SignedinDate":Date(),"Verified":false,"ProfilePicUrl":url,"Docid":docid]) { (err) in
                            if err != nil{
                                print(err ?? "error")
                            }
                            else{
                                DispatchQueue.main.async {
                                    alert.dismiss(animated: true, completion: nil)
                                    self.performSegue(withIdentifier: "SignupToTab", sender: self)
                                    print("success")
                                
                            }
                        }
//                        self.db.collection("users").addDocument(data: ["FullName":fullName,"Emailid":email,"College":college,"HeIs":youAre,"Uid":result!.user.uid,"SignedinDate":Date(),"Verified":false,"ProfilePicUrl":url]) { (err) in
//                            if err != nil{
//                                print(err ?? "error adding signed in user data to database")
//                            }
//
//                            else
//                            {
//                                DispatchQueue.main.async {
//                                    alert.dismiss(animated: true, completion: nil)
//                                    self.performSegue(withIdentifier: "SignupToTab", sender: self)
//                                    print("success")
//                                }
//
//
//                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    func showAlert(err: String){
        let alert = UIAlertController(title: "Invalid", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style:.default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    
    func universityPicker()
    {
        let picker = UIPickerView()
        picker.delegate = self
        picker.tag = 1
        universityTextField.inputView = picker
    }
    
    func youArePicker()
    {
        let picker = UIPickerView()
        picker.delegate = self
        picker.tag = 2;
        youAreTextField.inputView = picker
    }
}

extension SignUpViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1
        {
            return Colleges.count
        }
        else
        {
            return YouAre.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1
        {
            return Colleges[row]
            
        }
        else{
            return YouAre[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            universityTextField.text = Colleges[row]
        }
        else{
            youAreTextField.text = YouAre[row]
        }
    }
}
