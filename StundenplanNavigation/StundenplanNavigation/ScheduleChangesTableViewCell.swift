//
//  ScheduleChangesTableViewCell.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewCell: UITableViewCell {

    @IBOutlet var oldDateLabel: UILabel!
    @IBOutlet var oldTimeLabel: UILabel!
    @IBOutlet var oldRoomLabel: UILabel!
    
    @IBOutlet var newDateLabel: UILabel!
    @IBOutlet var newTimeLabel: UILabel!
    @IBOutlet var newRoomLabel: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    //Height constraint with priority of 250. Change this to 999 and set the label to hidden to hide the label and update constraints(shrinking of Cell). Otherwise label will take the available space anyway. Priority is changed in data source.
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
