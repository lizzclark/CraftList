//
//  DataTransformer.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation
import UIKit

struct DataTransformer {
    func projectData(from projects: [Project]?) -> [ProjectData] {
        return projects?.compactMap({ projectData($0) }) ?? []
    }
    
    func projectData(_ project: Project?) -> ProjectData? {
        guard let project = project,
              let id = project.id,
              let name = project.name,
              let dateStarted = project.dateStarted else { return nil }
        let image: UIImage
        if let imageId = project.imageId {
            do {
                image = try ImageStorage(name: "idk", fileManager: .default).image(forKey: imageId.uuidString)
            } catch {
                image = UIImage(systemName: "cloud.sun")!
            }
        } else {
            image = UIImage(systemName: "trash.fill")!
        }
        return ProjectData(id: id, name: name, imageData: image.pngData(), dateStarted: dateStarted, dateFinished: project.dateFinished)
    }
}
