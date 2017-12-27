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
    var start : Date!
    var end : Date!
    var timer = Timer()
    var delegate : TableViewUpdater!
    private var lectureTuple : (lecture:Lecture, day:Int)!
    let ctrl = WidgetLectureController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLecture(lecture : (Lecture, Int)) {
        
        self.lectureTuple = lecture
        course.text = lecture.0.name
        room.text = lecture.0.room
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        timeFormatter.dateFormat = "HH:mm"
        let startTimeString = timeFormatter.string(from: lecture.0.startTime)
        let endTimeString = timeFormatter.string(from: lecture.0.endTime)
        time.text = "\(startTimeString) - \(endTimeString)"
        start = Date().combineDateAndTime(date: Date(), time: lecture.0.startTime)
        end = Date().combineDateAndTime(date: Date(), time: lecture.0.endTime)
        
        updateTimerAndView(start: start, end: end)
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func handleTimer() {
        updateTimerAndView(start: start, end: end)
    }
    
    func updateTimerAndView(start: Date, end: Date){
        let restMinutes = calculateRestMinutes(end)
        let lectureDuration = calculateLectureDuration(from: start, to: end)
        print("Rest Minutes: \(restMinutes)")
        print("Duration: \(lectureDuration)")
        let percentage = calculatePercentageRestMinutes(restMinutes, lectureDuration)
        
        let isToday = isTodayOrSameWeekdayInNextWeeks(lectureTuple.day)

        if restMinutes >= 0 && isToday{
            //if restMinutes >= 0 && restMinutes <= lectureDuration && isToday{
            if WidgetLectureController().isUpcomingLectureToday() && restMinutes <= lectureDuration{
                nowOutlet.text = "Jetzt"
                timerView.percentageOfHour = percentage
                timerView.setNeedsDisplay()
                restTime.text = "\(restMinutes) min."
            }else{
                nowOutlet.text = "Nächste"
                timerView.isHidden = true
                restTime.text = ""
            }
        }else{
            nowOutlet.text = getNowLabel(for: lectureTuple.day)
            timerView.isHidden = true
            restTime.text = ""
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func calculateRestMinutes(_ end : Date) -> Int{
        let start = Date()
        
        let calendar = Calendar.current
        let flags = Calendar.Component.minute
        let components = calendar.dateComponents([flags], from: start, to: end)
        return components.minute!
    }
    
    func calculateLectureDuration(from start: Date, to end: Date) -> Int{
        let calendar = Calendar.current
        let flags = Calendar.Component.minute
        let components = calendar.dateComponents([flags], from: start, to: end)
        return components.minute!
    }
    
    func calculatePercentageRestMinutes(_ minutes : Int, _ duration: Int) -> Double{
        let double = Double(minutes)/Double(duration)
        return double
    }
    
    func getNowLabel(for day: Int) -> String {
        let curWeekday = ctrl.getWeekday()
        let dif = day - curWeekday
        
        switch dif {
        case 1:
            return "Morgen"
        case 2:
            return "Übermorgen"
        default:
            let timeInterval = Double(dif*3600*24)
            let date = Date().addingTimeInterval(timeInterval)
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "de") as Locale!
            formatter.dateFormat = "dd.MM.YYYY"
            return formatter.string(from: date)
        }
        
    }
    
    private func isTodayOrSameWeekdayInNextWeeks(_ day: Int) -> Bool {
        print("Day+1= \(day+1) Weekday+1=\(ctrl.getWeekday()+1)")
        return (day+1) / (ctrl.getWeekday()+1) == 1
    }
    
    
    
    
    
}


protocol TableViewUpdater {
    func updateTableView(hide: Bool, timerView: TimerView)
}

