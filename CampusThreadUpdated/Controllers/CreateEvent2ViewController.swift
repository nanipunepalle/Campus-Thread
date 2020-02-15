//
//  CreateEvent2ViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 11/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import Firebase

class CreateEvent2ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    var eventName: String!
    var eventStartDate: Date!
    var eventEndDate: Date!
    var regFees: Int!
    var eventEmail: String!
    var eventphno: Double?
    var eventType: [String]!
    var eventStartDateString: String!
    var eventEndDateString: String!
    
    
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    let poster = UIImageView()
    let storage = Storage.storage()
    
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var uploadPosterTextField: UITextField!
    @IBOutlet weak var registrationLinkTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        uploadPosterTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            poster.image = image
        }
        self.dismiss(animated: true) {
            self.uploadPosterTextField.text = "Uploaded"
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let error = validateFields()
        if error != nil{
            showAlert(err: error!)
        }
        else{
            let alert = UIAlertController(title: "Adding your event", message: nil, preferredStyle: .alert)
            
            present(alert, animated: true) {
                
                
                
                let eventCollege = self.collegeTextField.text
                let eventBuilding = self.buildingTextField.text
                let eventCity = self.CityTextField.text
                let eventState = self.stateTextField.text
                let eventCountry = self.countryTextField.text
                let regLink = self.registrationLinkTextField.text
                let eventDesc = self.descriptionTextField.text
                let uid = Auth.auth().currentUser?.uid
                
                let ref = self.db.collection("EventDetails").document()
                
                let docid = ref.documentID
                
                //Uploading poster to firebase storage
                
                let storageRef = self.storage.reference()
                let imagesRef = storageRef.child("posters")
                let finalImageRef = imagesRef.child("\(docid).jpg")
                let data = self.poster.image?.jpegData(compressionQuality: 0.5)
                
                finalImageRef.putData(data!, metadata: nil) { (result, err) in
                    if err != nil{
                        print(err ?? "error in uploading poster")
                    }
                    else{
                        finalImageRef.downloadURL { (url, err) in
                            if err != nil{
                                print(err ?? "error downloading url")
                            }
                            else{
                                let posterUrl = url?.absoluteString
//                                print(posterUrl ?? "error in posterUrl")
                                ref.setData(["EventName": self.eventName!,
                                             "EventType": self.eventType!,
                                             "EventStartDate": self.eventStartDate!,
                                             "EventEndDate": self.eventEndDate!,
                                             "EventEmail": self.eventEmail!,
                                             "EventPhno": self.eventphno ?? 0,
                                             "EventRegFees": self.regFees!,"EventBuilding": eventBuilding!,
                                             "EventCity": eventCity!,
                                             "EventCollege": eventCollege!,
                                             "EventState": eventState!,
                                             "EventCountry": eventCountry!,
                                             "EventDescription": eventDesc!,
                                             "EventRegLink": regLink!,
                                             "EventPostedDate": Date().timeIntervalSince1970,
                                             "Uid": uid!,
                                             "Docid": docid,
                                             "PosterURL":posterUrl!,
                                             "EventEndTimeString": self.eventEndDateString!,
                                             "EventStartTimeString": self.eventStartDateString!]) { (err) in
                                                if err != nil{
                                                    print(err ?? "error uploading eventdetails to database")
                                                }
                                                else{
//                                                    print("event success")
                                                    DispatchQueue.main.async {
                                                        alert.dismiss(animated: true, completion: nil)
                                                        
                                                    }
                                                    self.navigationController?.popViewController(animated: false)
                                                    self.navigationController?.popViewController(animated: false)
                                                    
                                                    
                                                }
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    
    func validateFields() -> String?{
        if collegeTextField.text == "" || buildingTextField.text == "" || stateTextField.text == "" || countryTextField.text == "" || descriptionTextField.text == "" || CityTextField.text == "" || registrationLinkTextField.text == "" {
            return "Fill all required Fields"
        }
        return nil
    }
    
    func showAlert(err: String){
        let alert = UIAlertController(title: "Invalid", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style:.default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
}
