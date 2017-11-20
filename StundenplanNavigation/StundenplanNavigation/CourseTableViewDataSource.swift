//
//  CourseTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewDataSource: NSObject, UITableViewDataSource {
    
    var tmpSelectedCourses : TmpSelectedCourses
    fileprivate var tupleArray : [(key: String, value: [Course])]!
    
    
    init (tmpSelectedCourses: TmpSelectedCourses){
        self.tmpSelectedCourses = tmpSelectedCourses
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return String(describing:tupleArray[section].key)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")!
        
        let course = tupleArray[indexPath.section].value[indexPath.row]
        
        cell.textLabel?.text = "\(course.nameDe)"
        cell.tintColor = appColor.tintColor
        
        if tmpSelectedCourses.contains(course: course) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tupleArray[section].value.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Courses wurden heruntergeladen, also kann man das geordnete Array generieren
        generateAlphabeticalOrderedCourses()
        return tupleArray.count
    }
    
    func generateAlphabeticalOrderedCourses() {
        
        tupleArray = []
        
        AllCourses().getCourses().forEach({course in
            
            if !tupleArray.contains(where: {$0.key == String(describing:course.nameDe[course.nameDe.startIndex])}){
                tupleArray.append((String(describing:course.nameDe[course.nameDe.startIndex]), []))
            }
        })
        
        for entry in AllCourses().getCourses() {
            let key = String(describing:entry.nameDe[entry.nameDe.startIndex])
            let index = tupleArray.index(where: {$0.key == key})!
            tupleArray[index].value.append(entry)
        }
        
        
    }
}


