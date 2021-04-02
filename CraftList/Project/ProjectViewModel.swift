//
//  ProjectViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation

struct ProjectViewModel {
    static let `default`: ProjectViewModel = {
        ProjectViewModel(name: "", dateStarted: Date())
    }()
    
    var name: String
    var dateStarted: Date
}
