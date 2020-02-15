//
//  EventViewCell.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 12/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import Firebase

class EventViewCell: UITableViewCell {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var events = [Event]()
    var onClickCallback: (() -> Int)?
    
    var click: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadEvents()
    }
    
    @IBOutlet weak var postedProfilePic: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var postedPersonName: UILabel!
    
    @IBOutlet weak var postedPersonCollege: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func contactButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func moreIfoButtonPressed(_ sender: UIButton) {
//        self.loadEvents()
        
        if let indexPath = onClickCallback?(){
            
            
                
            DispatchQueue.main.async {
                print(indexPath)
                let vc = EventsInfoViewController()
                let currentEvent = self.events[indexPath]
                print(currentEvent.eventStartDate)
                vc.name = currentEvent.eventCity
                self.click?()
//                self.vc.eventStartDateString = currentEvent.eventStartDate
//                self.vc.eventEndDateString = currentEvent.eventEndDate
            }
            
            
            
            
        }
        
    }
    func loadEvents(){
        db.collection("EventDetails").order(by: "EventPostedDate",descending: true).addSnapshotListener { (querySnapshot, err) in
            
            self.events = []
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
                            
                            self.events.append(newEvent)
                            print(newEvent)
//                            print(self.event)
//                            print(new)
                        }
                    }
                }
            }
        }
        
    }
}
