//
//  UpdateProfileViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 12/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import Firebase

class UpdateProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    let db = Firestore.firestore()
    let picker = UIImagePickerController()
    let storage = Storage.storage()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePicImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func storeImage(){
        let userUid = Auth.auth().currentUser?.uid
//        print(userUid )
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("ProfilePicimages")
        let finalImageRef = imagesRef.child("\(userUid!).jpg")
        let data = profilePicImageView.image?.jpegData(compressionQuality: 0.5)
        
        let uploadTask = finalImageRef.putData(data!, metadata: nil) { (metadata, err) in
            if err != nil{
                print(err ?? "ERR")
            }
            else{
                finalImageRef.downloadURL { (url, err) in
                    if err != nil{
                        print(err ?? "error")
                    }
                    else{
                        let picUrl = url?.absoluteString
                        var docid: String = ""
                        self.db.collection("users").whereField("Uid", isEqualTo: userUid!).addSnapshotListener { (querySnapshot, err) in
                            if err != nil{
                                print(err ?? "error")
                            }
                            else{
                                if let querySnapshotDocuments = querySnapshot?.documents{
                                    for doc in querySnapshotDocuments{
                                        let data = doc.data()
                                        docid = data["Docid"] as! String
                                        self.db.collection("users").document(docid).updateData(["ProfilePicUrl" : picUrl!]) { (err) in
                                            if err != nil{
                                                print(err ?? "error")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }
                }
            }
        }
        
        uploadTask.resume()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Adding your event", message: nil, preferredStyle: .alert)
        
        present(alert, animated: true) {
            self.storeImage()
        }
        
        
        DispatchQueue.main.async {
            alert.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
}
