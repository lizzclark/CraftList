//
//  ProjectDetailsViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import Combine

class ProjectDetailsViewModel {
    let dateStartedLabel = "Date Started"
    let dateFinishedLabel = "Date Finished"
    let editLabel = "Edit"
    let wipLabel = "Work in Progress"

    struct Data {
        let name: String
        let dateStarted: Date
        let dateFinished: Date?
        let dateStartedText: String
        let dateFinishedText: String?
    }
    
    @Published var project: Data?
    
    private let id: UUID
    private let service: ProjectService
    private var cancellables = Set<AnyCancellable>()
    
    init(id: UUID, service: ProjectService = ProjectService()) {
        self.service = service
        self.id = id
        fetchData()
    }
    
    private func fetchData() {
        service.getProject(id: id)
            .sink { [weak self] projectData in
                guard let self = self else { return }
                self.project = self.transform(projectData)
            }
            .store(in: &cancellables)
    }
    
    private func transform(_ projectModel: ProjectModel) -> Data {
        var dateFinishedText: String?
        if let finishDate = projectModel.dateFinished {
            dateFinishedText = DateFormatter.longDateFormatter.string(from: finishDate)
        }
        return Data(name: projectModel.name,
                    dateStarted: projectModel.dateStarted,
                    dateFinished: projectModel.dateFinished,
                    dateStartedText: DateFormatter.longDateFormatter.string(from: projectModel.dateStarted),
                    dateFinishedText: dateFinishedText)
    }
}
