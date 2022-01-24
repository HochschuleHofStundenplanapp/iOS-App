//
//  ArtificialIntelligence.swift
//  StundenplanNavigation
//
//  Created by Paul Forstner on 04.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework
class ArtificialIntelligence: NSObject {
    let startStringArray : [String] = ["start", "beginn", "ab "]
    let endStringArray : [String] = [" ende"]
    let recurrenceStringArray : [String] = ["14-tägig" , "14 tägig", "14tägig", "14 tage", "14-tage",  "14tage", "zweiwöchig", "zwei wochen"]
    let notParseableStringArray : [String] = ["außer", "ohne"]
    var calendarWeekArray : [Int] = []
    let periodStringArray : [String] = ["-", "bis"]
    let wrongPeriodArray : [String] = ["online-anmeldung", " termine:", "grundbildung messtechnik -"]

    
    public func iterationOfLecture(comment: String, start: Date, end: Date) -> iterationState {
        
        let tmpComment = comment.lowercased()
        
        if isParseAble(comment: tmpComment) == false {
            return iterationState.notParsable
        }
        
        if containsEnumeration(comment: tmpComment) == true {
            return iterationState.calendarWeeks
        }
        
        if individualDate(start: start, end: end) == true {
            return iterationState.individualDate
        }
        
        if checkIteration(comment: tmpComment) == true {
            return iterationState.twoWeeks
        }
        
        return iterationState.weekly
    }
    
    private func isParseAble(comment: String) -> Bool{
        for string in notParseableStringArray {
            if comment.contains(string) {
                return false
            }
        }
        return true
    }
    
    private func containsEnumeration(comment: String) -> Bool{
        let tmpComment = comment.lowercased()
        let tmpCommentLength = tmpComment.count
        
        
        for i in (0..<tmpCommentLength) {
            var kw = ""
            var count = 0
            var enumeration = false
            
            
            let index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
            if Int(String(tmpComment[index])) != nil {
                
                while enumeration == false {
                    var newIndex = tmpComment.index(index, offsetBy: count)
                    
                    if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                        kw += String(tmpComment[newIndex])
                        count += 1
                        
                    } else if i + count < tmpCommentLength && String(tmpComment[newIndex]) == "," {
                        if Int(kw) != nil {
                            calendarWeekArray.append(Int(kw)!)
                            kw = ""
                        }
                        count += 1
                    } else if i + count < tmpCommentLength && String(tmpComment[newIndex]) == " " {
                        count += 1
                    } else if i + count + 2 < tmpCommentLength && String(tmpComment[newIndex]) == "u" {
                        newIndex = tmpComment.index(index, offsetBy: count + 1)
                        if String(tmpComment[newIndex]) == "n" {
                            newIndex = tmpComment.index(index, offsetBy: count + 2)
                            if String(tmpComment[newIndex]) == "d" {
                                count += 3
                                if Int(kw) != nil {
                                    calendarWeekArray.append(Int(kw)!)
                                    kw = ""
                                }
                            } else {
                                if Int(kw) != nil {
                                    calendarWeekArray.append(Int(kw)!)
                                    kw = ""
                                }
                                count = 0
                                enumeration = true
                            }
                        } else {
                            if Int(kw) != nil {
                                calendarWeekArray.append(Int(kw)!)
                                kw = ""
                            }
                            count = 0
                            enumeration = true
                        }
                    } else {
                        if Int(kw) != nil {
                            calendarWeekArray.append(Int(kw)!)
                            kw = ""
                        }
                        count = 0
                        enumeration = true
                    }
                }
            }
            if calendarWeekArray.count > 2 {
                return true
            } else {
                calendarWeekArray.removeAll()
            }
        }
        return false
    }
    
    //gibt true zurück wenn es ein Blocktermin ist
    private func individualDate(start: Date, end: Date) -> Bool{
        
        let calendar = Calendar.current
        let startDay = calendar.component(.day, from: start)
        let startMonth = calendar.component(.month, from: start)
        let endDay = calendar.component(.day, from: end)
        let endMonth = calendar.component(.month, from: end)
        
        if startMonth == endMonth {
            if startDay == endDay {
               return true
            }
        }

        return false
    }
    
    //gibt true zurück wenn die Vorlesung alle 14 Tage ist
    private func checkIteration(comment: String) -> Bool{
        for iteration in recurrenceStringArray{
            if comment.contains(iteration){
                return true
            }
        }
        return false
    }
    
    public func checkPeriod(comment: String) -> (String, String){
        var tmpComment = comment.lowercased()
        var start = ""
        var end = ""
        
        forLoop : for wrongPeriod in wrongPeriodArray {
            if tmpComment.contains(wrongPeriod) {
                
                let startIndex = tmpComment.range(of: wrongPeriod)!
                var stringToDelete = tmpComment
                
                stringToDelete.removeSubrange(tmpComment.startIndex..<startIndex.upperBound)
                
                for i in (0..<stringToDelete.count) {
                    let index = stringToDelete.index(stringToDelete.startIndex, offsetBy: i)
                    for period in periodStringArray {
                        let firstLetter : String = String(period[period.startIndex])
                        
                        if String(stringToDelete[index]) == firstLetter {
                            let periodLength = period.count
                            let indexEnd = stringToDelete.index(index, offsetBy: periodLength)
                            let potentialPeriod = stringToDelete[index..<indexEnd]
                            
                            if potentialPeriod == period {
                                end = getNextCalendarWeekOrDate(comment: stringToDelete, keyword: period, length: 3)
                                if end != ""{
                                    if tmpComment.range(of: end) == nil && end.count >= 5 {
                                        end.removeSubrange(end.index(end.endIndex, offsetBy: -5)..<end.endIndex)
                                    }
                                    let endIndex = tmpComment.range(of: end)!
                                    tmpComment.removeSubrange(startIndex.lowerBound..<endIndex.upperBound)
                                    break forLoop
                                }
                            }
                        }
                    }
                }
            }
        }
        for period in periodStringArray {
            while tmpComment.contains(period) {
                start = getPreviousCalendarWeekOrDate(comment: tmpComment, keyword: period, length: 3)
                end = getNextCalendarWeekOrDate(comment: tmpComment, keyword: period, length: 3)
                
                if start != "" && end != "" {
                    return (start, end)
                } else {
                    let range = tmpComment.range(of: period)!
                    tmpComment.removeSubrange(range.lowerBound..<range.upperBound)
                }
            }
        }
        return ("", "")
    }
    
    public func checkStart(comment: String) -> String {
        let tmpComment = comment.lowercased()
        
        for start in startStringArray {
            if tmpComment.contains(start){
                return getNextCalendarWeekOrDate(comment: tmpComment, keyword: start, length: tmpComment.count)
            }
        }
        return ""
    }
    
    public func checkEnd(comment: String) -> String{
        let tmpComment = comment.lowercased()
        
        for end in endStringArray {
            if tmpComment.contains(end){
                return getNextCalendarWeekOrDate(comment: tmpComment, keyword: end, length: tmpComment.count)
            }
        }
        return ""
    }
    
    private func getNextCalendarWeekOrDate(comment: String, keyword: String, length: Int) -> String{
        
        var tmpComment = comment
        var kw = ""
        var range = tmpComment.range(of: keyword)!
        
        tmpComment.removeSubrange(tmpComment.startIndex..<range.upperBound)
        
        let tmpCommentLength = tmpComment.count
        var count = 1
        
        var tmpLength = length
        
        if tmpCommentLength < tmpLength {
            tmpLength = tmpCommentLength
        }
        
        for i in (0..<2) {
            if tmpCommentLength > i && tmpCommentLength > 0{
                var index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
                
                if tmpComment[index] == "k" && tmpCommentLength > i + 1{
                    index = tmpComment.index(tmpComment.startIndex, offsetBy: i + 1)
                    
                    if tmpComment[index] == "w" {
                        tmpLength += 3
                    }
                }
            }
        }
        
        for i in (0..<tmpLength) {
            var index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
            
            if Int(String(tmpComment[index])) != nil {
                kw = String(tmpComment[index])
                var newIndex = tmpComment.index(index, offsetBy: count)
                
                if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                    kw += String(tmpComment[newIndex])
                    count += 1
                    newIndex = tmpComment.index(index, offsetBy: count)
                }
                
                if i + count < tmpCommentLength && tmpComment[newIndex] == "." {
                    
                    var potentialDate = "\(kw)."
                    count += 1
                    newIndex = tmpComment.index(index, offsetBy: count)
                    
                    if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                        potentialDate += String(tmpComment[newIndex])
                        count += 1
                        newIndex = tmpComment.index(index, offsetBy: count)
                        
                        if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                            potentialDate += String(tmpComment[newIndex])
                            count += 1
                            newIndex = tmpComment.index(index, offsetBy: count)
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        dateFormatter.locale = Locale(identifier: "de_DE")
                        
                        if i + count < tmpCommentLength && tmpComment[newIndex] == "." {
                            potentialDate += "."
                            
                            count += 2
                            
                            if i + count >= tmpCommentLength {
                                let calendar = Calendar.current
                                let currentDate = Date()
                                var currentYear = calendar.component(.year, from: currentDate)
                                let season = currentDate.checkSemester()
                                
                                if season == "WS" {
                                    index = potentialDate.index(potentialDate.startIndex, offsetBy: 3)
                                    newIndex = potentialDate.index(index, offsetBy: 2)
                                    range = index ..< newIndex
                                    let month = Int(potentialDate[range])
                                    
                                    if month! < 9 {
                                        currentYear += 1
                                    }
                                }
                                
                                potentialDate += String(currentYear)
                                
                                if dateFormatter.date(from: potentialDate) != nil {
                                    return potentialDate
                                }
                                return ""
                            }
                            
                            newIndex = tmpComment.index(index, offsetBy: count + 1)
                            var range = index ..< newIndex
                            
                            let date = String(tmpComment[range])
                            
                            if dateFormatter.date(from: date) != nil {
                                count += 2
                                
                                if i + count >= tmpCommentLength {
                                    return date
                                }
                                
                                newIndex = tmpComment.index(index, offsetBy: count + 1)
                                range = index ..< newIndex
                                let newDate = String(tmpComment[range])
                                
                                if dateFormatter.date(from: newDate) != nil {
                                    return newDate
                                }
                                return date
                            }
                            
                            let calendar = Calendar.current
                            let currentDate = Date()
                            var currentYear = calendar.component(.year, from: currentDate)
                            let season = currentDate.checkSemester()
                            
                            if season == "WS" {
                                index = potentialDate.index(potentialDate.startIndex, offsetBy: 3)
                                newIndex = potentialDate.index(index, offsetBy: 2)
                                range = index ..< newIndex
                                if let month = Int(potentialDate[range]) {
                                    if month < 9 {
                                        currentYear += 1
                                    }
                                }
                            }
                            
                            potentialDate += String(currentYear)
                            if dateFormatter.date(from: potentialDate) != nil {
                                return potentialDate
                            }
                        } else {
                            let calendar = Calendar.current
                            let currentDate = Date()
                            var currentYear = calendar.component(.year, from: currentDate)
                            let season = currentDate.checkSemester()
                            
                            if season == "WS" {
                                index = potentialDate.index(potentialDate.startIndex, offsetBy: 3)
                                newIndex = potentialDate.index(index, offsetBy: 2)
                                range = index ..< newIndex
                                let month = Int(potentialDate[range])
                                
                                if month! < 9 {
                                  currentYear += 1
                                }
                            }
                            
                            potentialDate += ".\(currentYear)"
                            
                            if dateFormatter.date(from: potentialDate) != nil {
                                return potentialDate
                            }
                            return ""
                        }
                    } else {
                        return kw
                    }
                } else {
                    return kw
                }
            }
        }
        return ""
    }
    
    private func getPreviousCalendarWeekOrDate(comment: String, keyword: String, length: Int) -> String{
        var tmpComment = comment
        var kw = ""
        var range = tmpComment.range(of: keyword)!
        var calendarweekExist = false
        
        tmpComment.removeSubrange(range.lowerBound..<tmpComment.endIndex)
        
        let tmpCommentLength = tmpComment.count
        
        tmpComment = String(tmpComment.reversed())
        var count = 0
        var tmpLength = length
        
        if cwExist(comment: tmpComment, position: 0) == true {
            tmpLength += 3
            calendarweekExist = true
        }
        
        if tmpCommentLength < tmpLength {
            tmpLength = tmpCommentLength
        }
        
        for i in (0..<tmpLength) {
            var index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
            
            if i + count < tmpCommentLength {
                if Int(String(tmpComment[index])) != nil || tmpComment[index] == "."  {
                    var newIndex = tmpComment.index(index, offsetBy: count)
                    var potentialDate = ""
                    
                    for j in (1..<6) {
                        if i + count < tmpCommentLength {
                            newIndex = tmpComment.index(index, offsetBy: count)
                            
                            if Int(String(tmpComment[newIndex])) != nil {
                                kw += String(tmpComment[newIndex])
                            } else if tmpComment[newIndex] == "."{
                                potentialDate = "\(kw)."
                                count += 1
                                newIndex = tmpComment.index(index, offsetBy: count)
                                break
                            } else {
                                if cwExist(comment: tmpComment, position: i) == true || calendarweekExist == true && kw.count <= 2 {
                                    kw = String(kw.reversed())
                                    return kw
                                } else {
                                    return ""
                                }
                            }
                            count = j
                        }
                    }
                    
                    if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                        potentialDate += String(tmpComment[newIndex])
                        count += 1
                        newIndex = tmpComment.index(index, offsetBy: count)
                        
                        if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                            potentialDate += String(tmpComment[newIndex])
                            count += 1
                            newIndex = tmpComment.index(index, offsetBy: count)
                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        dateFormatter.locale = Locale(identifier: "de_DE")
                        
                        if i + count < tmpCommentLength && tmpComment[newIndex] == "." {
                            potentialDate += "."
                            count += 1
                            newIndex = tmpComment.index(index, offsetBy: count)
                            
                            if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                                potentialDate += String(tmpComment[newIndex])
                                count += 1
                                newIndex = tmpComment.index(index, offsetBy: count)
                                
                                if i + count < tmpCommentLength && Int(String(tmpComment[newIndex])) != nil {
                                    potentialDate += String(tmpComment[newIndex])
                                }
                                
                                potentialDate = String(potentialDate.reversed())
                                
                                if dateFormatter.date(from: potentialDate) != nil {
                                    return potentialDate
                                } else {
                                    let calendar = Calendar.current
                                    let currentDate = Date()
                                    var currentYear = calendar.component(.year, from: currentDate)
                                    let season = currentDate.checkSemester()
                                    
                                    if season == "WS" {
                                        index = potentialDate.index(potentialDate.startIndex, offsetBy: 3)
                                        newIndex = potentialDate.index(index, offsetBy: 2)
                                        range = index ..< newIndex
                                        let month = Int(potentialDate[range])
                                        
                                        if month! < 9 {
                                            currentYear += 1
                                        }
                                    }
                                    
                                    potentialDate += String(currentYear)
                                    
                                    if dateFormatter.date(from: potentialDate) != nil {
                                        return potentialDate
                                    }
                                }
                            }
                        } else {
                            if cwExist(comment: tmpComment, position: i) == true || calendarweekExist == true {
                                kw = String(potentialDate.reversed())
                                kw.remove(at: kw.index(before: kw.endIndex))
                                return kw
                            } else {
                                let calendar = Calendar.current
                                let currentDate = Date()
                                var currentYear = calendar.component(.year, from: currentDate)
                                let season = currentDate.checkSemester()
                                
                                potentialDate = String(potentialDate.reversed())
                                
                                if season == "WS" {
                                    index = potentialDate.index(potentialDate.startIndex, offsetBy: 3)
                                    newIndex = potentialDate.index(index, offsetBy: 2)
                                    range = index ..< newIndex
                                    let month = Int(potentialDate[range])
                                    
                                    if month! < 9 {
                                        currentYear += 1
                                    }
                                }
                                potentialDate += ".\(String(currentYear))"
                                
                                if dateFormatter.date(from: potentialDate) != nil {
                                    return potentialDate
                                }
                            }
                            return ""
                        }
                    }
                }   
            }
        }
        return ""
    }

    private func cwExist(comment: String, position: Int) -> Bool{
        var length = 4
        if position > 0 {
            length = 4
        }
        if comment.count > position + length{
            for i in (position..<position + length) {
                var index = comment.index(comment.startIndex, offsetBy: i)
                
                if comment[index] == "w" {
                    index = comment.index(comment.startIndex, offsetBy: i + 1)
                    
                    if comment[index] == "k" {
                        return true
                    }
                }
            }
        }
        return false
    }
}
