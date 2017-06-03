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
    
    func numberOfEntries(for section : Int) -> Int
    {
        return userdata.selectedSchedule.daySize(at: section)
    }
    
    func getElement(at indexPath : IndexPath) -> Lecture
    {
        return userdata.selectedSchedule.lecture(at: indexPath)
    }
    
    func getOneDimensionalList() -> [Lecture]{
    //Noch nicht getestet

        let lectures = userdata.selectedSchedule.lectures
        
        var newList : [Lecture] = [Lecture]()
        
        for day in lectures{
            for lecture in day{
                newList.append(lecture)
            }
        }
        return newList
    }
}
