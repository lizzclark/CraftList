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
}
