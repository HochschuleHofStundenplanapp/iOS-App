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
    
    func course(at row:Int) -> Course{
        return serverData.allCourses[row]
    }
    
    func getCourses() ->[Course]{
        return serverData.allCourses
    }
    
    func numberOfEntries() -> Int
    {
        return serverData.allCourses.count
    }
    
    func setCourses(courses: [Course]){
        serverData.allCourses = courses
    }
    
    func sort(){
            serverData.allCourses.sort(by: {$0.nameDe < $1.nameDe})
    }
    
    func clear() {
        serverData.allCourses.removeAll()
    }
}
