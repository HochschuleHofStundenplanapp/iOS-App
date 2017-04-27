//
//  JsonCourses.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 27.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

import Foundation

class JsonCourses {
    fileprivate var pCourses : [Course]?
    
    var courses : [Course]? {
        get {
            return pCourses
        }
    }
    
    init? (data : Data)
    {
        let jsonT = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        guard let json = jsonT else {
            return nil
        }
        extractCourses(json)
    }
    
    fileprivate func extractCourses(_ json : AnyObject)
    {
        guard let jsonData = JSONData.fromObject(json) else
        {
            return
        }
        guard let allResults = jsonData["courses"]?.array as [JSONData]! else
        {
            return
        }
        
        pCourses = []
        
        for i in allResults
        {
            let con = (i["course"]?.string)!
            let nameD = (i["labels"]?["de"]?.string)!
            let nameE = (i["labels"]?["en"]?.string)!
            let sem = (i["semester"]?.array)!
            
            
            for s in sem{
                
                let newCourse = Course(contraction : con, nameDe: nameD, nameEn: nameE, semester: s.string!)
                
                pCourses?.append(newCourse)
                
//                newSem.list.append(tmp)
            }
//            newSem.list.sort(){$0.name < $1.name}
            
//            let newCourse = Course(contraction : con, nameDe: nameD, nameEn: nameE, semesters: newSem)
//            pCourses?.append(newCourse)
            
        }
    }
}
