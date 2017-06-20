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
        return serverData.allChanges.count
    }
    
    func getElement(at index : Int) -> ChangedLecture
    {
        return serverData.allChanges[index]
    }
    
    func getChangedLectures() -> [ChangedLecture] {
        return serverData.allChanges
    }
    
    func append(chLectures : [ChangedLecture]) {
        
        //Check chLecture duplicates

        
        for lec in chLectures{
            serverData.allChanges.append(lec)
        }
    }
    
    func clear() {
        serverData.allChanges.removeAll()
    }
}
