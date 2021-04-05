//
//  DataTransformer.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation

struct DataTransformer {
    func projectData(from projects: [Project]?) -> [ProjectData] {
        return projects?.compactMap({ projectData($0) }) ?? []
    }
    
    func projectData(_ project: Project?) -> ProjectData? {
        guard let project = project,
              let id = project.id,
              let name = project.name,
              let dateStarted = project.dateStarted else { return nil }
        return ProjectData(id: id, name: name, imageData: project.image, dateStarted: dateStarted, dateFinished: project.dateFinished)
    }
}
