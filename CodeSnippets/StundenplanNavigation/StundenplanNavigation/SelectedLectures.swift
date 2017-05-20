//
//  SelectedLectures.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SelectedLectures: NSObject {

    fileprivate var userdata = UserData.sharedInstance
    
    func numberOfEntries() -> Int
    {
        return userdata.selectedLectures.count
    }
    
    func getElement(from i : Int) -> Lecture
    {
        return userdata.selectedLectures[i]
    }
    
    func set(element : Lecture, at i : Int)
    {
        userdata.selectedLectures[i] = element
    }
    
    func remove(at i : Int)
    {
        userdata.selectedLectures.remove(at: i)
    }
    
    func append(element : Lecture)
    {
        userdata.selectedLectures.append(element)
    }
    
    func clear()
    {
        userdata.selectedLectures = []
    }

}
