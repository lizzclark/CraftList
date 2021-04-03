//
//  ProjectTransformer.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation

struct ProjectTransformer {
    func projectData(from projects: [Project]?) -> [ProjectData] {
        return projects?.compactMap({ transform($0) }) ?? []
    }
    
    private func transform(_ project: Project) -> ProjectData? {
        guard let id = project.id,
              let name = project.name,
              let dateStarted = project.dateStarted else { return nil }
        return ProjectData(id: id, name: name, dateStarted: dateStarted, dateFinished: project.dateFinished)
    }
}
