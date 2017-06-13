//
//  ArtificialIntelligence.swift
//  StundenplanNavigation
//
//  Created by Paul Forstner on 04.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class ArtificialIntelligence: NSObject {
    let startArray : [String] = ["start", "beginn", "ab "]
    let endArray : [String] = [" ende"]
    let iterationArray : [String] = ["14-tägig" , "14 tägig", "14tägig", "14 tage", "14-tage",  "14tage", "zweiwöchig", "zwei wochen"]
    let notParseAbleArray : [String] = ["außer"]
    var calendarWeekArray : [Int] = []
    let periodArray : [String] = ["-", "bis"]
    let wrongPeriodArray : [String] = ["online-anmeldung", " termine:"]

    
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
        for string in notParseAbleArray {
            if comment.contains(string) {
                return false
            }
        }
        return true
    }
    
    private func containsEnumeration(comment: String) -> Bool{
        let tmpComment = comment.lowercased()
        let tmpCommentLength = tmpComment.characters.count
        
        for i in (0..<tmpCommentLength) {
            var kw = ""
            var count = 0
            var enumeration = false
            
            let index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
            if Int(String(tmpComment.characters[index])) != nil {
                
                while enumeration == false {
                    var newIndex = tmpComment.index(index, offsetBy: count)
                    
                    if i + count < tmpCommentLength && Int(String(tmpComment.characters[newIndex])) != nil {
                        kw += String(tmpComment.characters[newIndex])
                        count += 1
                        
                    } else if i + count < tmpCommentLength && String(tmpComment.characters[newIndex]) == "," {
                        if Int(kw) != nil {
                            calendarWeekArray.append(Int(kw)!)
                            kw = ""
                        }
                        count += 1
                    } else if i + count < tmpCommentLength && String(tmpComment.characters[newIndex]) == " " {
                        count += 1
                    } else if i + count + 2 < tmpCommentLength && String(tmpComment.characters[newIndex]) == "u" {
                        newIndex = tmpComment.index(index, offsetBy: count + 1)
                        if String(tmpComment.characters[newIndex]) == "n" {
                            newIndex = tmpComment.index(index, offsetBy: count + 2)
                            if String(tmpComment.characters[newIndex]) == "d" {
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
                calendarWeekArray.removeAll()
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
        for iteration in iterationArray{
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
        
        for wrongPeriod in wrongPeriodArray {
            if tmpComment.contains(wrongPeriod) {
                
                let startIndex = tmpComment.range(of: wrongPeriod)!
                var stringToDelete = tmpComment
                
                stringToDelete.removeSubrange(tmpComment.startIndex..<startIndex.upperBound)
                
                for i in (0..<stringToDelete.characters.count) {
                    var index = stringToDelete.index(stringToDelete.startIndex, offsetBy: i)
                    
                    if stringToDelete.characters[index] == "-" {
                        end = getNextCalendarWeekOrDate(comment: stringToDelete, keyword: "-", length: 3)
                        if end != ""{
                            let endIndex = tmpComment.range(of: end)!
                            tmpComment.removeSubrange(startIndex.lowerBound..<endIndex.upperBound)
                            break
                        }
                    } else if stringToDelete.characters[index] == "b" {
                        index = stringToDelete.index(stringToDelete.startIndex, offsetBy: i + 1)
                        if stringToDelete.characters[index] == "i" {
                            index = stringToDelete.index(stringToDelete.startIndex, offsetBy: i + 2)
                            if stringToDelete.characters[index] == "s" {
                                end = getNextCalendarWeekOrDate(comment: stringToDelete, keyword: "bis", length: 3)
                                if end != ""{
                                    let endIndex = tmpComment.range(of: end)!
                                    tmpComment.removeSubrange(startIndex.lowerBound..<endIndex.upperBound)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        for period in periodArray {
            
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
        
        for start in startArray {
            if tmpComment.contains(start){
                return getNextCalendarWeekOrDate(comment: tmpComment, keyword: start, length: tmpComment.characters.count)
            }
        }
        return ""
    }
    
    public func checkEnd(comment: String) -> String{
        let tmpComment = comment.lowercased()
        
        for end in endArray {
            if tmpComment.contains(end){
                return getNextCalendarWeekOrDate(comment: tmpComment, keyword: end, length: tmpComment.characters.count)
            }
        }
        return ""
    }
    
    private func getNextCalendarWeekOrDate(comment: String, keyword: String, length: Int) -> String{
        
        var tmpComment = comment
        var kw = ""
        let range = tmpComment.range(of: keyword)!
        
        tmpComment.removeSubrange(tmpComment.startIndex..<range.upperBound)
        
        let tmpCommentLength = tmpComment.characters.count
        var count = 1
        
        var tmpLength = length
        
        if tmpCommentLength < tmpLength {
            tmpLength = tmpCommentLength
        }
        
//        for i in (0..<2) {
//            var index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
//            
//            if tmpComment.characters[index] == "k" {
//                index = tmpComment.index(tmpComment.startIndex, offsetBy: i + 1)
//                
//                if tmpComment.characters[index] == "w" {
//                    tmpLength += 3
//                }
//            }
//        }
        
        for i in (0..<tmpLength) {
            let index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
            
            if Int(String(tmpComment.characters[index])) != nil {
                kw = String(tmpComment.characters[index])
                var newIndex = tmpComment.index(index, offsetBy: count)
                
                if i + count < tmpCommentLength && Int(String(tmpComment.characters[newIndex])) != nil {
                    kw += String(tmpComment.characters[newIndex])
                    count += 1
                    newIndex = tmpComment.index(index, offsetBy: count)
                    
                    if i + count < tmpCommentLength && tmpComment.characters[newIndex] == "." {
                        count += 5
                        
                        if i + count > tmpCommentLength {
                            return kw
                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        dateFormatter.locale = Locale(identifier: "de_DE")
                        
                        newIndex = tmpComment.index(index, offsetBy: count + 1)
                        var range = index ..< newIndex
                        
                        let date = tmpComment.substring(with: range)
                        
                        if dateFormatter.date(from: date) != nil {
                            count += 2
                            
                            if i + count > tmpCommentLength {
                                return date
                            }
                            
                            newIndex = tmpComment.index(index, offsetBy: count + 1)
                            range = index ..< newIndex
                            let newDate = tmpComment.substring(with: range)
                            
                            if dateFormatter.date(from: newDate) != nil {
                                return newDate
                            }
                            return date
                        } else {
                            return kw
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
        let range = tmpComment.range(of: keyword)!
        var calendarweekExist = false
        
        tmpComment.removeSubrange(range.lowerBound..<tmpComment.endIndex)
        
        let tmpCommentLength = tmpComment.characters.count
        
        tmpComment = String(tmpComment.characters.reversed())
        
        var count = 1
        var tmpLength = length
        
        if cwExist(comment: tmpComment, position: 0) == true {
            tmpLength += 3
            calendarweekExist = true
        }
        
        if tmpCommentLength < tmpLength {
            tmpLength = tmpCommentLength
        }
        
        
        for i in (0..<tmpLength) {
            let index = tmpComment.index(tmpComment.startIndex, offsetBy: i)
            
            if Int(String(tmpComment.characters[index])) != nil {
                kw = String(tmpComment.characters[index])
                var newIndex = tmpComment.index(index, offsetBy: count)
                
                if i + count < tmpCommentLength && Int(String(tmpComment.characters[newIndex])) != nil {
                    kw += String(tmpComment.characters[newIndex])
                    count += 7
                    
                    if i + count > tmpCommentLength {
                        if cwExist(comment: tmpComment, position: i) == true || calendarweekExist == true {
                            kw = String(kw.characters.reversed())
                            return kw
                        } else {
                            return ""
                        }
                    }
                    
                    count += 2
                    if i + count > tmpCommentLength {
                        count -= 2
                    }
                    
                    newIndex = tmpComment.index(index, offsetBy: count)
                    
                    var range = index ..< newIndex
                    
                    var date = tmpComment.substring(with: range)
                    date = String(date.characters.reversed())
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    dateFormatter.locale = Locale(identifier: "de_DE")
                    
                    if dateFormatter.date(from: date) != nil {
                        return date
                    } else {
                        
                        count -= 2
                        newIndex = tmpComment.index(index, offsetBy: count)
                        range = index ..< newIndex
                        date = tmpComment.substring(with: range)
                        date = String(date.characters.reversed())
                        
                        if dateFormatter.date(from: date) != nil {
                            return date
                        }
                        
                        if cwExist(comment: tmpComment, position: i) == true || calendarweekExist == true {
                            kw = String(kw.characters.reversed())
                            return kw
                        } else {
                            return ""
                        }
                    }
                } else {
                    if cwExist(comment: tmpComment, position: i) == true || calendarweekExist == true {
                        kw = String(kw.characters.reversed())
                        return kw
                    } else {
                        return ""
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
        if comment.characters.count > position + length{
            for i in (position..<position + length) {
                var index = comment.index(comment.startIndex, offsetBy: i)
                
                if comment.characters[index] == "w" {
                    index = comment.index(comment.startIndex, offsetBy: i + 1)
                    
                    if comment.characters[index] == "k" {
                        return true
                    }
                }
            }
        }
        return false
    }

}
