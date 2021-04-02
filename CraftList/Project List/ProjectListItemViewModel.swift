//
//  ProjectListItemViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation

struct ProjectListItemViewModel {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    let name: String
    let dateStarted: String
    let dateFinished: String?
    
    init(name: String, dateStarted: String, dateFinished: String?) {
        self.name = name
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
    }
}
