//
//  ProjectListItemViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import SwiftUI

struct ProjectListItemViewModel {
    let name: String
    let image: Image?
    let dateStarted: Date
    let dateFinished: Date?
    var dateStartedText: String {
        return "Started \(DateFormatter.longDateFormatter.string(from: dateStarted))"
    }
    var dateFinishedText: String? {
        guard let date = dateFinished else { return nil }
        return "Finished \(DateFormatter.longDateFormatter.string(from: date))"
    }
    
    init(name: String, image: Image?, dateStarted: Date, dateFinished: Date?) {
        self.name = name
        self.image = image
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
    }
}
