//
//  EventsInfoViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 15/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit

class EventsInfoViewController: UIViewController {
    
    
    var name: String?

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var eventStartDate: UILabel!
    
    @IBOutlet weak var eventEndDate: UILabel!
    @IBOutlet weak var eventRegFees: UILabel!
    
    @IBOutlet weak var eventVenue: UILabel!
    
    @IBOutlet weak var eventContactDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(name)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func eventRegsterButtonPressed(_ sender: UIButton) {
    }
    

}
