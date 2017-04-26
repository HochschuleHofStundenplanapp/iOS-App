//
//  LecturesTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDelegate: NSObject, UITableViewDelegate {
    var mainViewController : LecturesTableViewController!
    
    init(ctrl : LecturesTableViewController) {
        mainViewController = ctrl
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        header.textLabel?.textColor = UIColor.hawBlue
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 73
    }

}
