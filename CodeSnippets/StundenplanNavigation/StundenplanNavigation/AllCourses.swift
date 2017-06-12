//
//  AllCourses.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 12.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class AllCourses: NSObject {

    fileprivate var serverData = ServerData.sharedInstance
    
    func course(at indexPath: IndexPath) -> Course{
        return serverData.allCourses[indexPath.row]
    }
    
    func numberOfEntries() -> Int
    {
        return serverData.allCourses.count
    }
}
