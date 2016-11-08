//
//  JsonRecommendation.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

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
            
            var newSem : [String] = []
            
            for s in sem{
                newSem.append(s.string!)
            }

            let newCourse = Course(contraction : con, nameDe: nameD, nameEn: nameE, semester: newSem)
            pCourses?.append(newCourse)
        }
    }
}
