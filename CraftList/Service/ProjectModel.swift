//
//  ProjectModel.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import UIKit

struct ProjectModel {
    let id: UUID
    let name: String
    let dateStarted: Date
    let dateFinished: Date?
    let hasImage: Bool
}
