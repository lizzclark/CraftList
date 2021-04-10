//
//  ProjectData.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation

struct ProjectData {
    let id: UUID
    let name: String
    let dateStarted: Date
    let dateFinished: Date?
}

struct AddProjectData {
    let name: String
    let imageData: Data?
    let dateStarted: Date
    let dateFinished: Date?
}
