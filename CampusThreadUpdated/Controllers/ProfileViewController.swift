//
//  ProfileViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 11/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    let userId = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    func loadImage(){
        db.collection("users").whereField("Uid", isEqualTo: userId!).addSnapshotListener { (querySnapshot, err) in
            if err != nil{
                print(err ?? "error")
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        let profilePicUrl = data["ProfilePicUrl"] as! String
                        print(profilePicUrl)
                        let storageRef = self.storage.reference(forURL: profilePicUrl)
                        storageRef.getData(maxSize: 1*1024*1024) { (data, err) in
                            
                            if err != nil {
                                print(err ?? "error")
                            }
                            else{
                                let pic = UIImage(data: data!)
                                self.profilePicImageView.image = pic
                                
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
