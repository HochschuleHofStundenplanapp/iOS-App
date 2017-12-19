//
//  AllChanges.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 13.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

public class AllChanges: NSObject {

    fileprivate var userData = UserData.sharedInstance
    
    public func numberOfEntries(for section : Int) -> Int
    {
        return userData.oldChanges.count
    }
    
    public func getElement(at index : Int) -> ChangedLecture
    {
        return userData.oldChanges[index]
    }
    
    public func getChangedLectures() -> [ChangedLecture] {
        return userData.oldChanges
    }
    
    public func append(chLectures : [ChangedLecture]) {
        
        for lec in chLectures{
            //Check chLecture duplicates
            if !userData.oldChanges.contains(lec){
                userData.oldChanges.append(lec)
            }
        }
    }
    
    public func clear() {
        userData.oldChanges.removeAll()
    }
}
