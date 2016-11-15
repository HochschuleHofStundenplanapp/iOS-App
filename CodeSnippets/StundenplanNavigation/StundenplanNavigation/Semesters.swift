//
//  Semesters.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Semesters: NSObject {

    var list : [Semester] = []
    
    func toggleSemesterAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    func isSelected(index: Int) -> Bool{
        return list[index].selected
    }
}
