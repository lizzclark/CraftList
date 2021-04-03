//
//  ProjectService.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation
import Combine

struct ProjectModel {
    let id: UUID
    let name: String
    let dateStarted: Date
    let dateFinished: Date?
}

struct ProjectService {
    private let dataStore: DataStore
    
    init(dataStore: DataStore = DataStore.shared) {
        self.dataStore = dataStore
    }
    
    func projects() -> AnyPublisher<[ProjectModel], Never> {
        return dataStore
            .fetchProjects()
            .map({ data in
                return data.map { projectData in
                    return ProjectModel(id: projectData.id, name: projectData.name, dateStarted: projectData.dateStarted, dateFinished: projectData.dateFinished)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func addProject(name: String, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<String, Never> {
        return Future<String, Never> { promise in
            dataStore.add(projectData: AddProjectData(name: name, dateStarted: dateStarted, dateFinished: dateFinished)) {
                promise(.success(name))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteProject(id: UUID) -> AnyPublisher<String, Never> {
        return Future<String, Never> { promise in
            dataStore.deleteProject(id: id) { projectName in
                promise(.success(projectName))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getProject(id: UUID) -> AnyPublisher<ProjectModel, Never> {
        return Future<ProjectModel, Never> { promise in
            dataStore.fetchProject(id: id) { projectData in
                let model = ProjectModel(id: projectData.id, name: projectData.name, dateStarted: projectData.dateStarted, dateFinished: projectData.dateFinished)
                promise(.success(model))
            }
        }
        .eraseToAnyPublisher()
    }
}
