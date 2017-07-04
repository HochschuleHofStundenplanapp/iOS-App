//
//  AllChanges.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 13.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class AllChanges: NSObject {

    fileprivate var serverData = ServerData.sharedInstance
    
    func numberOfEntries(for section : Int) -> Int
    {
        return UserData.sharedInstance.oldChanges.count
    }
    
    func getElement(at index : Int) -> ChangedLecture
    {
        return UserData.sharedInstance.oldChanges[index]
    }
    
    func getChangedLectures() -> [ChangedLecture] {
        return UserData.sharedInstance.oldChanges
    }
    
    func append(chLectures : [ChangedLecture]) {
        
        for lec in chLectures{
            //Check chLecture duplicates
            if !UserData.sharedInstance.oldChanges.contains(lec){
                UserData.sharedInstance.oldChanges.append(lec)
            }
        }
    }
    
    func clear() {
        UserData.sharedInstance.oldChanges.removeAll()
    }
}
