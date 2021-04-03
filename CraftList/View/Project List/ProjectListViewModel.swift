//
//  ProjectListViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI
import Combine

class ProjectListViewModel: ObservableObject {
    
    struct Project: Hashable {
        let id: UUID
        let name: String
        let dateStarted: Date
        let dateFinished: Date?
    }
    
    let navBarTitle = "Projects"
    
    @Published var projects: [Project] = []
    
    private let service: ProjectService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ProjectService = ProjectService()) {
        self.service = service
        subscribeToProjects()
    }
    
    private func subscribeToProjects() {
        service.projects()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    // handle error
                    break
                }
            }) { [weak self] projects in
                guard let self = self else { return }
                self.projects = self.viewModels(from: projects)
            }
            .store(in: &cancellables)
    }
    
    func viewModels(from projects: [ProjectModel]) -> [Project] {
        return projects.map { Project(id: $0.id, name: $0.name, dateStarted: $0.dateStarted, dateFinished: $0.dateFinished) }
    }
    
    func deleteItems(offsets: IndexSet) {
        offsets.map { projects[$0] }.forEach({ deleteProject(id: $0.id) })
    }
    
    private func deleteProject(id: UUID) {
        service.deleteProject(id: id)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    // handle error
                    break
                }
            }) { _ in
                // successfully deleted
            }
            .store(in: &cancellables)
    }
}
