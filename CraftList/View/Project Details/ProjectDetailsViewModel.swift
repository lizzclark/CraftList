//
//  ProjectDetailsViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation

struct ProjectDetailsViewModel {
    let dateStartedLabel = "Date Started"
    let dateFinishedLabel = "Date Finished"
    let editLabel = "Edit"
    let wipLabel = "Work in Progress"

    let name: String
    let dateStarted: Date
    let dateFinished: Date?
    let dateStartedText: String
    let dateFinishedText: String?

    init(name: String, dateStarted: Date, dateFinished: Date?) {
        self.name = name
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
        self.dateStartedText = DateFormatter.longDateFormatter.string(from: dateStarted)
        if let finishDate = dateFinished {
            self.dateFinishedText = DateFormatter.longDateFormatter.string(from: finishDate)
        } else {
            dateFinishedText = nil
        }
    }
}
