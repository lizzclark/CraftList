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
    
    init(_ project: Project) {
        self.name = project.name ?? ""
        if let dateStarted = project.dateStarted {
            self.dateStarted = ProjectListItemViewModel.dateFormatter.string(from: dateStarted)
        } else {
            self.dateStarted = ""
        }
    }
    
    init(name: String, dateStarted: String) {
        self.name = name
        self.dateStarted = dateStarted
    }
}
