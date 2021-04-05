//
//  ProjectListViewModel.swift
//  CraftList
//
//  Created by Lizz Clark on 02/04/2021.
//

import SwiftUI
import Combine

class ProjectListViewModel: ObservableObject {
    
    struct Project {
        let id: UUID
        let name: String
        let image: Image?
        let dateStarted: Date
        let dateFinished: Date?
    }
    
    let navBarTitle = "Projects"
    let loadingText = "Fetching your projects..."
    
    @Published var projects: [Project] = []
    
    private let service: ProjectServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ProjectServiceProtocol = ProjectService()) {
        self.service = service
    }
    
    func fetchProjects() {
        service.getProjects()
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
        return projects.map { project in
            var projectImage: Image?
            if let uiImage = project.image {
                projectImage = Image(uiImage: uiImage)
            }
            return Project(id: project.id, name: project.name, image: projectImage, dateStarted: project.dateStarted, dateFinished: project.dateFinished)
        }
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
            }) { [weak self] _ in
                self?.fetchProjects()
            }
            .store(in: &cancellables)
    }
}
