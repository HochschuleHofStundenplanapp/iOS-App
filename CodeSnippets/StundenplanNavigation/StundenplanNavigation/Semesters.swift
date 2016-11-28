//
//  Semesters.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Semesters{

    var list : [Semester] = []
    
    func toggleSemesterAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    func mergeSemesters(semesters : [Semester]){
        for localSemester in list{
            for loadedSemester in semesters{
                if(localSemester.equal(compareTo: loadedSemester)){
                    loadedSemester.selected = localSemester.selected
                }
            }
        }
        list = semesters
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
