//
//  ModelTransformer.swift
//  CraftList
//
//  Created by Lizz Clark on 05/04/2021.
//

import UIKit

struct ModelTransformer {
    func model(from projectData: ProjectData) -> ProjectModel {
        var image: UIImage?
        if let imageData = projectData.imageData {
            image = UIImage(data: imageData)
        }
        return ProjectModel(id: projectData.id,
                            name: projectData.name,
                            image: image,
                            dateStarted: projectData.dateStarted,
                            dateFinished: projectData.dateFinished)
    }
}
