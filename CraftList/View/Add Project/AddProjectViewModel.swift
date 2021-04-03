//
//  AddProjectViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import Combine

class AddProjectViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var dateStarted: Date = Date()
    @Published var isFinished = false
    @Published var dateFinishedFieldValue: Date = Date()
    
    let title = "Add a Project"
    let projectNameLabel = "Project Name"
    let dateStartedLabel = "Date Started"
    let statusLabel = "Status"
    let wipLabel = "WIP"
    let finishedLabel = "Finished"
    let dateFinishedLabel = "Date Finished"
    let saveLabel = "Save"
    
    private let service: ProjectService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ProjectService = ProjectService()) {
        self.service = service
    }
    
    func save(_ completion: @escaping () -> Void) {
        var finishDate: Date?
        if isFinished {
            finishDate = dateFinishedFieldValue
        }
        service.addProject(name: name, dateStarted: dateStarted, dateFinished: finishDate)
            .sink { _ in
                completion()
            }
            .store(in: &cancellables)
    }
}
