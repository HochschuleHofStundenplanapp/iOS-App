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
    private var lecture : Lecture!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    func setLecture(lecture : Lecture, now : String) {
        
        self.lecture = lecture
        nowOutlet.text = now
        course.text = lecture.name
        room.text = lecture.room
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        timeFormatter.dateFormat = "HH:mm"
        let startTimeString = timeFormatter.string(from: lecture.startTime)
        let endTimeString = timeFormatter.string(from: lecture.endTime)
        time.text = "\(startTimeString) - \(endTimeString)"
        start = Date().combineDateAndTime(date: Date(), time: lecture.startTime)
        end = Date().combineDateAndTime(date: Date(), time: lecture.endTime)
        
        updateTimerAndView(start: start, end: end)
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func handleTimer() {
        updateTimerAndView(start: start, end: end)
    }
    
    func updateTimerAndView(start: Date, end: Date){
        let restMinutes = calculateRestMinutes(end)
        let lectureDuration = calculateLectureDuration(from: start, to: end)
        print("Duration: \(lectureDuration)")
        let percentage = calculatePercentageRestMinutes(restMinutes, lectureDuration)
        
        if restMinutes >= 0 && restMinutes <= lectureDuration{
            if WidgetLectureController().isUpcomingLectureToday(){
                nowOutlet.text = "Jetzt"
                timerView.percentageOfHour = percentage
                timerView.setNeedsDisplay()
                restTime.text = "\(restMinutes) min."
            }else{
                nowOutlet.text = "Am 1.1.2000"
                timerView.isHidden = true
                restTime.text = ""
            }
        }else{  //Wird aufgerufen, sobald die Stunde um ist oder keine andere Stunde heute mehr stattfindet
            nowOutlet.text = "Nächste"
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
}

protocol TableViewUpdater {
    func updateTableView(hide: Bool, timerView: TimerView)
}
