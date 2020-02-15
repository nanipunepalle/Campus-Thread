//
//  EventsViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 11/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//
import UIKit
import Firebase

class EventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var event = [Event]()
    
    let f: String = "lalith"
    
    @IBOutlet weak var eventtableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventtableView.delegate = self
        eventtableView.dataSource = self
        eventtableView.register(UINib(nibName: "EventViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadEvents()
        //        navigationItem.hidesBackButton = true
        //        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
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
                            DispatchQueue.main.async {
                                //                                _ = IndexPath(row: self.event.count - 1, section: 0)
                                self.eventtableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let events = event[indexPath.row]
        
        let path = indexPath.row

        let cell = eventtableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! EventViewCell
        
        
        cell.onClickCallback = {
           
            return path
        }
        cell.click = {
             self.performSegue(withIdentifier: "EventsToMoreinfo", sender: self)
        }
        
        
        // Code for poster extraction from data Base
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
                        cell.postedPersonCollege.text = data["College"] as? String
                        
                        let profilePicStorageRef = self.storage.reference(forURL: (data["ProfilePicUrl"] as? String)!)
                        print(profilePicStorageRef)
                        profilePicStorageRef.getData(maxSize: 1*1024*1024) { (data, err) in
                            
                            if err != nil{
                                print(err ?? "error")
                            }
                            else{
                                cell.postedProfilePic.image = UIImage(data: data!)
                                
                            }
                        }
                    }
                }
            }
        }
        return cell
        
    }
    
    //     func prepare(for)
    
    //    func prep
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //
    //        func inde(num: Int)
    //        {
    //            print(num)
    //        }
    //            let secondVc = segue.destination as! EventsInfoViewController
    //
    //    //        secondVc.eventDescription.text = events.eventDesc
    //    //        secondVc.eventContactDetails.text = events.eventEmail
    //    //        secondVc.eventVenue.text = events.eventCollege
    //    //        //            secondVc.eventRegFees.text = String(events.regFees)
    //    //        secondVc.eventEndDate.text = events.eventStartDate
    //    //        secondVc.eventEndDate.text = events.eventEndDate
    //
    //            print("succes  info")
    //            secondVc.name = f
    //        }
    
    
    
    
    
}
