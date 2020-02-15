//
//  EventCollectionViewCell.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 14/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var postedPersonName: UILabel!
    @IBOutlet weak var userProfilePicImageView: UIImageView!
    @IBOutlet weak var postedCollegeName: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
