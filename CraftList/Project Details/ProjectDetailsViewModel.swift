//
//  ProjectDetailsViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation

struct ProjectDetailsViewModel {
    let name: String
    let dateStarted: Date?
    
    init(_ project: Project) {
        self.name = project.name ?? "Unnamed Project"
        #warning("how to handle optional stuff")
        self.dateStarted = project.dateStarted
    }
    
    init(name: String, dateStarted: Date) {
        self.name = name
        self.dateStarted = dateStarted
    }
}
