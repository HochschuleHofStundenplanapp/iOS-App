//
//  ViewController.swift
//  EventDemo
//
//  Created by Jonas Beetz on 11.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    var savedEventId : String = ""
    let schnittstelle = Schnittstelle_Kalender()
    
    var startDate1 = Date()
    var endDate2 = Date()
    var startTime = Date()
    var endTime = Date()
    
    var lectrues = [Lecture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Responds to button to add event. This checks that we have permission first, before adding the
    // event
    @IBAction func addEvent(_ sender: UIButton) {
        var startDate = Date().addingTimeInterval(120)
        var endDate = startDate.addingTimeInterval(60 * 60) // One hour
        
        print("start\n")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let startDateString = "14.12.2016"
        let endDate2 = "30.1.2017"
        let start = dateFormatter.date(from: startDateString)
        let end = dateFormatter.date(from: endDate2)
        
        
        let timeFormatter = dateFormatter
        timeFormatter.dateFormat = "yyyy-mm-dd HH:mm"
        var startTime1 = "2001-01-01 8:00"
        var startTime = timeFormatter.date(from: startTime1)?.addingTimeInterval(3600)
        var endTime = startTime?.addingTimeInterval(60*90)
        
        
        let lecture = Lecture(id: 12345, name: "Testvorlesung", lecturer: "Herr Dozent", type: "Vorlesung", group: "Gruppe", starttime: startTime!, endTime: endTime!, startdate: start! , enddate: end!, day: "Mittwoch", room: "FA001", course: "MC", comment: "Ab WK 40", selected: true)
        
        startTime1 = "2001-01-01 9:45"
        startTime = timeFormatter.date(from: startTime1)?.addingTimeInterval(3600)
        endTime = startTime?.addingTimeInterval(60*90)
        let lecture1 = Lecture(id: 12345, name: "Testvorlesung", lecturer: "Herr Dozent", type: "Vorlesung", group: "Gruppe", starttime: startTime!, endTime: endTime!, startdate: start! , enddate: end!, day: "Mittwoch", room: "FA001", course: "MC", comment: "Ab WK 40", selected: true)
        
        startTime1 = "2001-01-01 11:30"
        startTime = timeFormatter.date(from: startTime1)?.addingTimeInterval(3600)
        endTime = startTime?.addingTimeInterval(60*90)
        let lecture2 = Lecture(id: 12345, name: "Testvorlesung", lecturer: "Herr Dozent", type: "Vorlesung", group: "Gruppe", starttime: startTime!, endTime: endTime!, startdate: start! , enddate: end!, day: "Mittwoch", room: "FA001", course: "MC", comment: "Ab WK 40", selected: true)
        
        startTime1 = "2001-01-02 9:45"
        startTime = timeFormatter.date(from: startTime1)?.addingTimeInterval(3600)
        endTime = startTime?.addingTimeInterval(60*90)
        let lecture3 = Lecture(id: 12345, name: "Testvorlesung", lecturer: "Herr Dozent", type: "Vorlesung", group: "Gruppe", starttime: startTime!, endTime: endTime!, startdate: start! , enddate: end!, day: "Mittwoch", room: "FA001", course: "MC", comment: "Ab WK 40", selected: true)
        
        startTime1 = "2001-01-02 11:30"
        startTime = timeFormatter.date(from: startTime1)?.addingTimeInterval(3600)
        endTime = startTime?.addingTimeInterval(60*90)
        let lecture4 = Lecture(id: 12345, name: "Testvorlesung", lecturer: "Herr Dozent", type: "Vorlesung", group: "Gruppe", starttime: startTime!, endTime: endTime!, startdate: start! , enddate: end!, day: "Mittwoch", room: "FA001", course: "MC", comment: "Ab WK 40", selected: true)
        lectrues.append(lecture)
        lectrues.append(lecture1)
        lectrues.append(lecture2)
        lectrues.append(lecture3)
        lectrues.append(lecture4)
        
        schnittstelle.createAllEvents(lectures: lectrues)
        
        //TODO Events speichern
        
        print("create end\n")
    }
    
    // Responds to button to remove event. This checks that we have permission first, before removing the
    // event
    @IBAction func removeEvent(_ sender: UIButton) {
        schnittstelle.removeAllEvents(lectures: lectrues)
    }

}

