//
//  TaskDisplayController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation
import StundenplanFramework


class TaskDisplayController {
    private(set) var sortMode: SortMode
    private var dateSort: [Date] = []
    private var lectureSort: [String] = []
    private var tasks: [[Task]] = []
    
    var userData = UserData.sharedInstance
    
    init() {
        self.sortMode = .lecture
        reloadData()
    }
    
    init(sortMode: SortMode) {
        self.sortMode = sortMode
        reloadData()
    }
    
    
    // Getter
    func numberOfSections() -> Int {
        return tasks.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return tasks[section].count
    }
    
    func sectionHeaderTitle(at section: Int) -> String {
        switch sortMode {
        case .date:
            let date = dateSort[section]
            return date.formattedDate
        case .lecture:
            let lectureName = lectureSort[section]
            return lectureName
        }
    }
    
    func task(at indexPath: IndexPath) -> Task {
        return tasks[indexPath.section][indexPath.row]
    }
    
    func numberOfNotCompletedTasks() -> Int {
        var result = 0
        for task in userData.tasks {
            if !task.checked {
                result += 1
            }
        }
        return result
    }
    
    private func flatTaskArray() -> [Task] {
        var result: [Task] = []
        for array in tasks {
            for task in array {
                result.append(task)
            }
        }
        return result
    }
    
    
    // Setter
    func delete(at indexPath: IndexPath) {
        tasks[indexPath.section].remove(at: indexPath.row)
        userData.tasks = flatTaskArray()
        DataObjectPersistency().saveDataObject(items: userData)
        
        let nc = NotificationCenter.default
        nc.post(name: .completedTaskChanged, object: nil)
    }
    
    func deleteSection(at index: Int) {
        switch sortMode {
        case .date: dateSort.remove(at: index)
        case .lecture: lectureSort.remove(at: index)
        }
        tasks.remove(at: index)
        userData.tasks = flatTaskArray()
        DataObjectPersistency().saveDataObject(items: userData)
    }
    
    func switchSortMode(to sortMode: SortMode) {
        self.sortMode = sortMode
        reloadData()
    }
    
    func reloadData() {
        resetData()
        let allTasks = userData.tasks
        switch sortMode {
        case .date: sortByDate(for: allTasks)
        case .lecture: sortByLecture(for: allTasks)
        }
    }
    
    private func resetData() {
        dateSort = []
        lectureSort = []
        tasks = []
    }
    
    private func sortByDate(for tasks: [Task]) {
        let tasks = tasks.sorted { (task1, task2) -> Bool in
            let compareResult = task1.dueDate.compare(task2.dueDate)
            return compareResult == ComparisonResult.orderedAscending
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var currentDate: String? = nil
        var currentTaskIndex: Int = -1
        for task in tasks {
            let taskDueDate = task.dueDate
            if currentDate != dateFormatter.string(from: taskDueDate) {
                currentTaskIndex += 1
                dateSort.append(taskDueDate)
                self.tasks.append([])
                self.tasks[currentTaskIndex].append(task)
            } else {
                self.tasks[currentTaskIndex].append(task)
            }
            currentDate = dateFormatter.string(from: taskDueDate)
        }
    }
    
    private func sortByLecture(for tasks: [Task]) {
        let tasks = tasks.sorted { (task1, task2) -> Bool in
            return task1.lecture < task2.lecture
        }
        var currentLecture: String? = nil
        var currentTaskIndex: Int = -1
        for task in tasks {
            let taskLectureName = task.lecture
            if currentLecture != taskLectureName {
                currentTaskIndex += 1
                currentLecture = taskLectureName
                lectureSort.append(taskLectureName)
                self.tasks.append([])
                self.tasks[currentTaskIndex].append(task)
            } else {
                self.tasks[currentTaskIndex].append(task)
            }
            currentLecture = taskLectureName
        }
    }
    
    
    // Helper Classes
    enum SortMode {
        case date
        case lecture
    }
}
