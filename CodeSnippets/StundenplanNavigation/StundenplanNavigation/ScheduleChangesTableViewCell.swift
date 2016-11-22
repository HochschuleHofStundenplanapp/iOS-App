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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
