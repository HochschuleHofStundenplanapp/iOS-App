//
//  ScheduleTableViewCell.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 07.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var docent: UILabel!
    @IBOutlet weak var OpenButton: UIImageView!
    @IBOutlet weak var hasTaskView: UILabel!
    
    var isExpanded : Bool = false
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setExpandedState(newState : Bool){
        //print("Cell was expanded")
        isExpanded = newState
        }
}
