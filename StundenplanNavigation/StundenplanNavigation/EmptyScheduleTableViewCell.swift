//
//  EmptyScheduleTableViewCell.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 05.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class EmptyScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var textLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
