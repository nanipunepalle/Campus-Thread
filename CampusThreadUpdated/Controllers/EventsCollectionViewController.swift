//
//  EventsCollectionViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 14/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import Firebase

class EventsCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var event = [Event]()
    
    @IBOutlet weak var eventsCollectionViewCell: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsCollectionViewCell.delegate = self
        eventsCollectionViewCell.dataSource = self
        eventsCollectionViewCell.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCollectionCell")
        loadEvents()
        eventsCollectionViewCell.reloadData()
        // Do any additional setup after loading the view.
    }
    


 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return event.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eventsCollectionViewCell.dequeueReusableCell(withReuseIdentifier: "ReusableCollectionCell", for: indexPath) as! EventCollectionViewCell
        
        
        let events = event[indexPath.section]
        print(indexPath.section)
        print(indexPath)
//        cell.postedPersonName.text = "lalith"
//        cell.backgroundColor = UIColor.red
        
        let storageRef = storage.reference(forURL: events.posterurl)
        storageRef.getData(maxSize: 1*1024*1024) { (data, err) in
            let pic = UIImage(data: data!)
            cell.posterImageView.image = pic
        }
        
        db.collection("users").whereField("Uid", isEqualTo: events.uid).addSnapshotListener { (querySnapshot, err) in
            if err != nil{
                print(err ?? "error")
            }
            else{
                if let snapShotDocuments = querySnapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        cell.postedPersonName.text = data["FullName"] as? String
//                        print(data["FullName"] as? String)
//                        cell.postedPersonCollege.text = data["College"] as? String
                        cell.postedCollegeName.text = data["College"] as? String
                        
                        let profilePicStorageRef = self.storage.reference(forURL: (data["ProfilePicUrl"] as? String)!)
                        print(profilePicStorageRef)
                        profilePicStorageRef.getData(maxSize: 1*1024*1024) { (data, err) in

                            if err != nil{
                                print(err ?? "error")
                            }
                            else{
//                                cell.postedProfilePic.image = UIImage(data: data!)
                                cell.userProfilePicImageView.image = UIImage(data: data!)

                            }
                        }
                    }
                }
            }
        }
        
        return cell
       }

    
    
    func loadEvents(){
            db.collection("EventDetails").order(by: "EventPostedDate",descending: true).addSnapshotListener { (querySnapshot, err) in
                
                self.event = []
                if err != nil{
                    print(err ?? "error")
                }
                else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            if let eventName = data["EventName"] as? String,
                                let eventTypes = data["EventType"] as? [String],
                                let eventStartDate = data["EventStartTimeString"] as? String,
                                let eventEndDate = data ["EventEndTimeString"] as? String,
                                let eventPhno = data["EventPhno"] as? NSNumber,
                                let eventEmail = data["EventEmail"] as? String,
                                let eventRegFees = data["EventRegFees"] as? NSNumber,
                                let eventBuilding = data["EventBuilding"] as? String,
                                let eventCity = data["EventCity"] as? String,
                                let eventCollege = data["EventCollege"] as? String,
                                let eventState = data["EventState"] as? String,
                                let eventCountry = data["EventCountry"] as? String,
                                let eventRegLink = data["EventRegLink"] as? String,
                                let posterUrl = data["PosterURL"] as? String,
                                let eventdesc = data["EventDescription"] as? String,
                                let uid = data["Uid"] as? String{
                                
                                
                                let newEvent = Event(eventName: eventName, eventType: eventTypes, eventStartDate: eventStartDate, eventEndDate: eventEndDate,eventPhno: eventPhno, eventEmail: eventEmail, regFees: eventRegFees, eventCollege: eventCollege, eventBuilding: eventBuilding, eventCity: eventCity, eventState: eventState, eventCountry: eventCountry, eventDesc: eventdesc, eventRegLink: eventRegLink, posterurl: posterUrl, uid: uid)
                                
                                self.event.append(newEvent)
    //                            print(newEvent)

                                    self.eventsCollectionViewCell.reloadData()
                                
                            }
                        }
                    }
                }
            }
            
        }
    
}
