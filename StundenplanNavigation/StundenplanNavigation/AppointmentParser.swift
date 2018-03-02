//
//  AppointmentParser.swift
//  StundenplanFramework
//
//  Created by Bastian Kusserow on 08.01.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import Foundation
import SwiftSoup
import StundenplanFramework

class AppointmentParser {
    
    var delegate: AppointmentTableViewController?
    
    var html = ""
    
    init(){}
    
    
    func downloadAndParseAppointmentContent(){
        let myURLString = "https://www.hof-university.de/studierende/studienbuero/termine"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: myURL){(data,response,error) -> Void in
            if let error = error{
                print("Download of Appointments failed \(error.localizedDescription)")
                return
            }
            
            if let data = data{
                print("Download of Appointments ...")
                let website=String(data: data, encoding: .utf8)
                if let website = website{
                    let appointments = self.parseAppointments(html: website)
                    UserData.sharedInstance.appointments = appointments
                    UserData.sharedInstance.currentSemester = Date().checkSemester()
                    DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
                    
                    DispatchQueue.main.async {
                        self.delegate?.reloadAppointments()
                    }
                }
                
                
            }
        }
        task.resume()
    }
    
    private func parseAppointments(html: String) -> [Tuple]{
        
        let doc : Document = try! SwiftSoup.parse(html)
        
        //liefert 2 Tabellen (SS und WS)
        let table = try! doc.getElementsByClass("contenttable")
        
        //hier muss die richtige ausgewählt werden, anhand th-Text
        //ausgewählter index in table (0 oder 1)
        var table_index = 0
        
        //prüfen der table header
        if(table.size() == 2) {
            let th_first = try! table.first()!.getElementsByTag("th")
            
            let th_first_text = th_first.first()?.ownText()
            
            if(UserData.sharedInstance.currentSemester == "SS") {
                print("appointments for SS...")
                if(th_first_text?.contains("Sommersemester"))! {
                    print("appointments table index = 0")
                    table_index = 0
                } else {
                    print("appointments table index = 1")
                    table_index = 1
                }
            } else {
                print("appointments for WS...")
                if(th_first_text?.contains("Wintersemester"))! {
                    print("appointments table index = 0")
                    table_index = 0
                } else {
                    print("appointments table index = 1")
                    table_index = 1
                }
            }
        }
        
        let td = try! table.get(table_index).getElementsByTag("td")
        var appointmentArray = [Tuple]()
        var isDate = false
        var name = ""
        var heading : String? = try! table.get(table_index).getElementsByTag("th").first()!.ownText()
        var newHeading = heading
        var appointments = [Appointment]()
        var date = DateInterval()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "de")
        
        //print("appointment td-list: \(td.array().description)")
        
        for i in td.array(){
            let text = i.ownText()
            
            if text == ""{
                if let header = i.children().first(){
                    newHeading = header.ownText()
                }
                
            }
            else{
                if(!isDate){
                    name = text
                }else{
                    if(text.count < 12){
                        //print("TEXT: \(text)")
                        let onlyDate = dateFormatter.date(from: "\(text) 00:00:00")!
                        //print(onlyDate.description(with: Locale.init(identifier: "de")))
                        date = DateInterval(start: onlyDate, end: onlyDate)
                    }else{
                        let index = text.index(of: " ") ?? text.endIndex
                        let firstDateString = String(text[..<index])
                        let firstDate = dateFormatter.date(from: "\(firstDateString) 00:00:00")!
                        let endDateString = String(text[text.index(index, offsetBy: 2) ..< text.endIndex])
                        let endDate = dateFormatter.date(from: "\(endDateString) 23:59:00")!
                        date = DateInterval(start: firstDate, end: endDate)
                    }
                    let appointment = Appointment(name: name, date: date)
                    
                    if heading != newHeading {
                        appointments = []
                        heading = newHeading
                    }
                    
                    appointments.append(appointment)
                    //print(appointment)
                    //appointmentArray[heading!] = appointments
                    let first = appointmentArray.index(where: { tuple -> Bool in
                        return tuple.header == heading!
                    })
                    if let app = first {
                        
                        appointmentArray[app] = Tuple(name: appointmentArray[app].header,appointments: appointments)
                        
                    }else{
                        appointmentArray.append(Tuple(name: heading!, appointments: appointments))
                    }
                }
            }
            
            isDate = !isDate
        }
        return appointmentArray
    }
}



