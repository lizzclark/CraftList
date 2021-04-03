//
//  ProjectViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import CoreData

struct ProjectViewModel: Hashable {
    let name: String
    let dateStarted: Date
    let dateFinished: Date?
    
    init?(_ project: Project) {
        guard let name = project.name,
              let dateStarted = project.dateStarted else {
            return nil
        }
        self.name = name
        self.dateStarted = dateStarted
        self.dateFinished = project.dateFinished
    }
    
    var detailsViewModel: ProjectDetailsViewModel {
        let dateStartedText = DateFormatter.longDateFormatter.string(from: dateStarted)
        var dateFinishedText: String?
        if let dateFinished = dateFinished {
            dateFinishedText = DateFormatter.longDateFormatter.string(from: dateFinished)
        }
        return ProjectDetailsViewModel(name: name, dateStarted: dateStartedText, dateFinished: dateFinishedText)
    }
}
