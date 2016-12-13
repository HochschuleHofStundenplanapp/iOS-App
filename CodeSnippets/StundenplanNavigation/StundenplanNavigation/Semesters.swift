//
//  Semesters.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Semesters : NSCopying{

    var list : [Semester] = []
    
    init() {}
    
    init(semesters: [Semester]) {
        list = semesters
    }
    
    required init?(coder aDecoder: NSCoder) {
        list = aDecoder.decodeObject(forKey: "SemestersList") as! [Semester]
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encode(list, forKey:"SemestersList")
    }
    
    func toggleSemesterAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Semesters(semesters: self.list)
        return copy
    }
    
    func setSelektion(semesters : Semesters){
        
        
        for semester in semesters.list{
            if (semester.selected){
                for localsem in list{
                    if localsem.equal(compareTo: semester){
                        localsem.selected = semester.selected
                    }
                }
            }
        }
    }
    
    func isSelected(index: Int) -> Bool{
        return list[index].selected
    }
    
    //Liefert alle selektierten Semester
    func selectedSemesters() -> [Semester]{
        var selectedSemesters : [Semester] = []
        
        for sem in list{
            if (sem.selected){
                selectedSemesters.append(sem)
            }
        }
        
        return selectedSemesters
    }

}
