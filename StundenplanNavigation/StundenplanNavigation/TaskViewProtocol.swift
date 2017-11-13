//
//  TaskViewProtocol.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 19.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

protocol TaskViewProtocol {
    func receive(editedTaskIndexPath: IndexPath)
    func addedNewTask(otherVC: TaskOverviewViewController)
    func changed(filterCriteria: Bool)
}
