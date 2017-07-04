//
//  AllChanges.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 13.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class AllChanges: NSObject {

    fileprivate var userData = UserData.sharedInstance
    
    func numberOfEntries(for section : Int) -> Int
    {
        return userData.oldChanges.count
    }
    
    func getElement(at index : Int) -> ChangedLecture
    {
        return userData.oldChanges[index]
    }
    
    func getChangedLectures() -> [ChangedLecture] {
        return userData.oldChanges
    }
    
    func append(chLectures : [ChangedLecture]) {
        
        for lec in chLectures{
            //Check chLecture duplicates
            if !userData.oldChanges.contains(lec){
                userData.oldChanges.append(lec)
            }
        }
    }
    
    func clear() {
        userData.oldChanges.removeAll()
    }
}
