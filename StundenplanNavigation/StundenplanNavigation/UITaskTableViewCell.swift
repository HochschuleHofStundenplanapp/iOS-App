//
//  UITaskTableViewCell.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 17.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework
class UITaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskCompletedImageView: UIImageView!
    
    private var task: Task!
    private var indexPath: IndexPath!
    
    func display(task: Task, for viewMode: TaskDisplayController.SortMode, at indexPath: IndexPath) {
        self.task = task
        taskTitleLabel.text = task.title
        self.indexPath = indexPath
        switch viewMode {
        case .date:     taskDescriptionLabel.text = "\(task.lecture)"
        case .lecture:  taskDescriptionLabel.text = "\(task.dueDate.formattedDate)"
        }
        let completedImage = task.checked ? UIImage(named: "icon_checked") : UIImage(named: "icon_unchecked")
        taskCompletedImageView.image = completedImage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchTaskCompletionAction(_ sender: UIButton) {
        task.checked = !task.checked
        if let tableView = self.superview as? UITableView {
            tableView.reloadRows(at: [indexPath], with: .right)
        }
        let nc = NotificationCenter.default
        nc.post(name: .completedTaskChanged, object: nil)
        
        if(task.checked) {
            CalendarInterface.sharedInstance.removeTaskFromCalendar(task: task)
        } else {
            CalendarInterface.sharedInstance.addTaskToCalendar(task: task)
        }
    }
}
