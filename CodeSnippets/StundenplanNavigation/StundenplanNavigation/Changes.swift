//
//  Changes.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

class Changes {
    
    var changes : [ChangedLecture] = []
    
    func addChanges(cl : [ChangedLecture]){
        changes.append(contentsOf: cl)
    }
    
    func sort()
    {
        changes.sort(){
            ($0.name < $1.name)
        }
    }
}
