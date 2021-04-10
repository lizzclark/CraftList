//
//  ModelTransformer.swift
//  CraftList
//
//  Created by Lizz Clark on 05/04/2021.
//

import UIKit

struct ModelTransformer {
    func model(from projectData: ProjectData) -> ProjectModel {
        return ProjectModel(id: projectData.id,
                            name: projectData.name,
                            dateStarted: projectData.dateStarted,
                            dateFinished: projectData.dateFinished,
                            hasImage: projectData.hasImage)
    }
}
