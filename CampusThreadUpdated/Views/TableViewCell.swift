//
//  TableViewCell.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 09/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var postedCollegeName: UILabel!
    @IBOutlet weak var postedProfilePic: UIImageView!
    @IBOutlet weak var postedPersonName: UILabel!
    
    @IBOutlet weak var eventPosterImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: UIButton) {
    }
    @IBAction func contsctButtonPressed(_ sender: UIButton) {
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
    }
}
