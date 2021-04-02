//
//  ProjectListItemViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation

struct ProjectListItemViewModel {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    let name: String
    let dateStarted: String
    let dateFinished: String?
    
    init(_ project: Project) {
        self.name = project.name ?? ""
        if let dateStarted = project.dateStarted {
            let startDate = ProjectListItemViewModel.dateFormatter.string(from: dateStarted)
            self.dateStarted = "Started \(startDate)"
        } else {
            self.dateStarted = ""
        }
        if let dateFinished = project.dateFinished {
            let finishDate = ProjectListItemViewModel.dateFormatter.string(from: dateFinished)
            self.dateFinished = "Finished \(finishDate)"
        } else {
            self.dateFinished = nil
        }
    }
    
    init(name: String, dateStarted: String, dateFinished: String) {
        self.name = name
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
    }
}
