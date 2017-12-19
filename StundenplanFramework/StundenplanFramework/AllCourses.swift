//
//  AllCourses.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 12.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

public class AllCourses: NSObject {

    fileprivate var serverData = ServerData.sharedInstance
    
    public func course(at row:Int) -> Course{
        return serverData.allCourses[row]
    }
    
    public func getCourses() ->[Course]{
        return serverData.allCourses
    }
    
    public func numberOfEntries() -> Int
    {
        return serverData.allCourses.count
    }
    
    public func setCourses(courses: [Course]){
        serverData.allCourses = courses
    }
    
    public func sort(){
            serverData.allCourses.sort(by: {$0.nameDe < $1.nameDe})
    }
    
    public func clear() {
        serverData.allCourses.removeAll()
    }
}
