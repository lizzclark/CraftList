//
//  ProjectListItemViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import SwiftUI
import Combine

struct ProjectListItemViewModel {
    let id: UUID
    let name: String
    let imagePublisher: AnyPublisher<UIImage, Never>
    let dateStarted: Date
    let dateFinished: Date?
    var dateStartedText: String {
        return "Started \(DateFormatter.longDateFormatter.string(from: dateStarted))"
    }
    var dateFinishedText: String? {
        guard let date = dateFinished else { return nil }
        return "Finished \(DateFormatter.longDateFormatter.string(from: date))"
    }
    
    init(id: UUID,
         name: String,
         imagePublisher: AnyPublisher<UIImage, Never>,
         dateStarted: Date,
         dateFinished: Date?) {
        self.id = id
        self.name = name
        self.dateStarted = dateStarted
        self.dateFinished = dateFinished
        self.imagePublisher = imagePublisher
    }
}
