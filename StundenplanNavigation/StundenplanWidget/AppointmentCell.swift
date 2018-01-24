//
//  AppointmentCell.swift
//  StundenplanWidget
//
//  Created by Bastian Kusserow on 19.01.18.
//  Copyright © 2018 Hof University. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {

    @IBOutlet var AppointmentName: UILabel!
    @IBOutlet var timeOutlet: UILabel!
    @IBOutlet var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
