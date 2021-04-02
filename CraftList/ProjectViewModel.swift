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
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
        
    var listItemViewModel: ProjectListItemViewModel {
        let dateFormatter = ProjectViewModel.dateFormatter
        let dateStartedText = "Started \(dateFormatter.string(from: dateStarted))"
        var dateFinishedText: String?
        if let dateFinished = dateFinished {
            dateFinishedText = "Finished \(dateFormatter.string(from: dateFinished))"
        }
        return ProjectListItemViewModel(name: name, dateStarted: dateStartedText, dateFinished: dateFinishedText)
    }
    
    var detailsViewModel: ProjectDetailsViewModel {
        let dateFormatter = ProjectViewModel.dateFormatter
        let dateStartedText = dateFormatter.string(from: dateStarted)
        var dateFinishedText: String?
        if let dateFinished = dateFinished {
            dateFinishedText = dateFormatter.string(from: dateFinished)
        }
        return ProjectDetailsViewModel(name: name, dateStarted: dateStartedText, dateFinished: dateFinishedText)
    }
}
