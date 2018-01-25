//
//  widgetTableViewDataSource.swift
//  StundenplanWidget
//
//  Created by Bastian Kusserow on 30.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

class WidgetTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let lectureCtrl = WidgetLectureController()
    var expanded = false
    var delegate : TableViewUpdater!
    var firstIsNext = false
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if !AppointmentController.isLectureFreeDay(){
        let wCell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell") as! WidgetCell
        let (lecture, day) = lectureCtrl.getAllLecture()[indexPath.row]
        wCell.delegate = delegate
        
        
        wCell.setLecture(lecture: (lecture,day))
        
        // Kann man sicher besser machen
        if indexPath.row == 0 && wCell.nowOutlet.text == "Nächste" {
            firstIsNext = true
        }else if indexPath.row == 1 && firstIsNext && wCell.nowOutlet.text == "Nächste"{
            wCell.nowOutlet.text = "Übernächste"
        }
        if DataObjectPersistency().loadDataObject().showAppointments{
            if let appointment = checkForAppointment(on: wCell.nowOutlet.text!){
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell") as! AppointmentCell
                cell.AppointmentName.text = appointment.name
                cell.date.text = formatDate(interval: appointment.date)
               cell.timeOutlet.text = wCell.nowOutlet.text
               return cell
            }
        }
        
        
        return wCell
        /*}else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell") as! AppointmentCell
            cell.AppointmentName.text = AppointmentController.getFreeDayAppointment()?.name
            return cell
        }*/
    }
    
    func formatDate(interval : DateInterval) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        formatter.dateFormat = "dd.MM.YYYY"
        let start = formatter.string(from: interval.start)
        print(interval.start)
        print(interval.end)
        let end = interval.start != interval.end ? " - \(formatter.string(from:interval.end))" : ""
        
        return "\(start)\(end)"
    }
    
    func checkForAppointment(on aDate: String) -> Appointment? {
        let userData = DataObjectPersistency().loadDataObject()
        userData.appointments[1].appointments.append(Appointment(name: "Tag der Deutschen Einheit", date: DateInterval(start: Date(), duration: 0)))
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        formatter.dateFormat = "dd.MM.YYYY"
        let date = formatter.date(from: aDate)
        if let date = date {
        let appointments = userData.appointments
        
        for app in appointments[1].appointments {
            print(Calendar.current.startOfDay(for: app.date.start))
            
            if Calendar.current.startOfDay(for: app.date.start) == Calendar.current.startOfDay(for: date) { return app}
            
        }
        return nil
        }else{
            let date = getDateFrom(string: aDate)
            let appointments = userData.appointments
            for app in appointments[1].appointments {
                print("Else \(Calendar.current.startOfDay(for: app.date.start))")
                if Calendar.current.startOfDay(for: app.date.start) == Calendar.current.startOfDay(for: date) { return app}
            }
            
        }
        
        return nil
    }
    
    
    func getDateFrom(string:String) -> Date {
        let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        switch string {
        case "Jetzt":
            return midnight!
        case "Nächste":
            return midnight!
        case "Morgen":
            return Calendar.current.date(byAdding: .day, value: 1, to: midnight!)!
        case "Übermorgen":
            return Calendar.current.date(byAdding: .day, value: 2, to: midnight!)!
        default:
            return midnight!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expanded {
            return 2
        }else{
            return 1
        }
    }
    
    //MARK: Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = URL(string: "StundenplanNavigation://")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
}

