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
    
    init? (data: Data)
    {
        let jsonT = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        guard let json = jsonT else {
            return nil
        }
        extractCourses(json)
    }
    
    fileprivate func extractCourses(_ json : AnyObject)
    {
        //Zusammenfassen
        guard let jsonData = JSONData.fromObject(json),  let allResults = jsonData["courses"]?.array as [JSONData]!else
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
            
            var allSemesters: [Semester] = []
            
            let course = Course(contraction : con, nameDe: nameD, nameEn: nameE)
            
            for s in sem{
                
                let season = UserData.sharedInstance.selectedSeason
                
                let tmpSem = Semester(name: s.string!, course: course, season: season)
                allSemesters.append(tmpSem)
            }
    
            allSemesters.sort(){$0.name < $1.name}
            
            course.semesters = allSemesters
            
            pCourses?.append(course)
        }
        pCourses?.sort(){$0.nameDe < $1.nameDe}
    }
}
