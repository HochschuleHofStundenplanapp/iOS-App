//
//  WidgetCell.swift
//  StundenplanWidget
//
//  Created by Bastian Kusserow on 30.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

class WidgetCell: UITableViewCell {
    
    @IBOutlet var nowOutlet: UILabel!
    @IBOutlet var course: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var room: UILabel!
    @IBOutlet var timerView: TimerView!
    @IBOutlet var restTime: UILabel!
    fileprivate var start : Date!
    fileprivate var end : Date!
    fileprivate var timer = Timer()
    fileprivate var lectureTuple : (lecture:Lecture, day:Int)!
    fileprivate let ctrl = WidgetLectureController()
    var delegate : TableViewUpdater!
    
    func setLecture(lecture : (Lecture, Int)) {
        
        self.lectureTuple = lecture
        course.text = lecture.0.name
        room.text = lecture.0.room
        //Formatting the time
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "de") as Locale
        timeFormatter.dateFormat = "HH:mm"
        let startTimeString = timeFormatter.string(from: lecture.0.startTime)
        let endTimeString = timeFormatter.string(from: lecture.0.endTime)
        
        time.text = "\(startTimeString) - \(endTimeString)"
        start = Date().combineDateAndTime(date: Date(), time: lecture.0.startTime)
        end = Date().combineDateAndTime(date: Date(), time: lecture.0.endTime)
        
        updateTimerAndView()
        
        //Setting up the timer which updates the TimerView every minute
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTimerAndView), userInfo: nil, repeats: true)
        
        
    }
    
    /**
     Updates the Timer.
    */
    @objc func updateTimerAndView(){
        let restMinutes = calculateRestMinutes(end)
        let lectureDuration = calculateLectureDuration(from: start, to: end)
        let percentage = calculatePercentageRestMinutes(restMinutes, lectureDuration)
        
        let bIsToday = isToday(lectureTuple.day)

        // Sets the label accordingly.
        if restMinutes >= 0 && bIsToday{
            //TODO hier checken
            if WidgetLectureController().isUpcomingLectureToday() && restMinutes <= lectureDuration{
                nowOutlet.text = "JETZT"
                timerView.percentageOfHour = percentage
                restTime.text = "\(restMinutes) min"
                timerView.isHidden = false
                timerView.setNeedsDisplay()
            }else{
                nowOutlet.text = "HEUTE"
                timerView.isHidden = true
                restTime.text = ""
            }
        }else{
            nowOutlet.text = getNowLabel(for: lectureTuple.day)
            timerView.isHidden = true
            restTime.text = ""
        }
        
    }
    
    
    /**
     * Calculates the minutes from now till end parameter.
     * - parameter end: the end time.
     * - returns: the rest minutes as Int.
     */
    func calculateRestMinutes(_ end : Date) -> Int{
        let start = Date()
        
        let calendar = Calendar.current
        let flags = Calendar.Component.minute
        let components = calendar.dateComponents([flags], from: start, to: end)
        return components.minute!
    }
    
    /**
     Calculates the duration of the lecture.
     - parameters:
        - start: the start time of the lecture.
        - end: the end time of the lecture.
     - returns: The lecture duration.
    */
    func calculateLectureDuration(from start: Date, to end: Date) -> Int{
        let calendar = Calendar.current
        let flags = Calendar.Component.minute
        let components = calendar.dateComponents([flags], from: start, to: end)
        return components.minute!
    }
    
    /**
     * Calculates the percentage rest minutes for the timer to display.
     * - parameters:
     *     - minutes: the remaining minutes.
     *     - duration: the lecture duration.
     * - returns: The percentage value as a double between 0 and 1.
    */
    func calculatePercentageRestMinutes(_ minutes : Int, _ duration: Int) -> Double{
        let double = Double(minutes)/Double(duration)
        return double
    }
    
    /**
     * Calculates the string for the now label.
     *  # Values
     *   - Morgen
     *   - Übermorgen
     *   - Ein Datum nach übermorgen
     *  - parameter day: The day for which the string should be calculated.
    */
    func getNowLabel(for day: Int) -> String {
        let curWeekday = ctrl.getWeekday()
        let dif = day - curWeekday - 1
        
        switch dif {
        case 1:
            return "MORGEN"
        case 2:
            return "ÜBERMORGEN"
        default:
            let timeInterval = Double(dif*3600*24)
            let date = Date().addingTimeInterval(timeInterval)
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "de") as Locale
            formatter.dateFormat = "dd.MM.YYYY"
            return formatter.string(from: date)
        }
        
    }
    
    /**
     Calculates if the passed day parameter is today.
    */
    private func isToday(_ day: Int) -> Bool {
        //print("Day+1= \(day+1) Weekday+1=\(ctrl.getWeekday()+1)")
        return ((day+1) % (ctrl.getWeekday()+1) == 0)&&((day+1)/(ctrl.getWeekday()+1)==1)
    }

}


protocol TableViewUpdater {
    func updateTableView(hide: Bool, timerView: TimerView)
}

