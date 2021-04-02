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

    let name: String
    let dateStarted: String
    let dateFinished: String?

    init(name: String, dateStarted: String, dateFinished: String?) {
        self.name = name
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
    }
}
