//
//  ProjectDetailsViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import Foundation
import Combine

class ProjectDetailsViewModel: ObservableObject {
    let dateStartedLabel = "Date Started"
    let dateFinishedLabel = "Date Finished"
    let editLabel = "Edit"
    let wipLabel = "Work in Progress"
    let emptyStateLabel = "There's nothing here."
    let deleteTitle = "Are you sure?"
    let deleteMessage = "The project will be permanently deleted."
    let deleteLabel = "Delete"
    let cancelLabel = "Cancel"

    struct Data {
        let name: String
        let dateStarted: Date
        let dateFinished: Date?
        let dateStartedText: String
        let dateFinishedText: String?
    }
    
    @Published var project: Data?
    
    let id: UUID
    private let service: ProjectServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(id: UUID, service: ProjectServiceProtocol = ProjectService()) {
        self.service = service
        self.id = id
        fetchData()
    }
    
    func deleteProject() {
        service.deleteProject(id: id)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    // handle error
                    break
                }
            }) { [weak self] _ in
                self?.project = nil
            }
            .store(in: &cancellables)
    }
    
    private func fetchData() {
        service.getProject(id: id)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    // handle error
                    break
                }
            }) { [weak self] projectData in
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
