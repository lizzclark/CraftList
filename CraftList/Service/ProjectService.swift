//
//  ProjectService.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import UIKit
import Combine

enum ServiceError: Error {
    case failure
}

protocol ProjectServiceProtocol {
    func getProjects() -> AnyPublisher<[ProjectModel], ServiceError>
    func addProject(name: String, imageData: Data?, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<UUID, ServiceError>
    func deleteProject(id: UUID) -> AnyPublisher<String, ServiceError>
    func getProject(id: UUID) -> AnyPublisher<ProjectModel, ServiceError>
    func getImage(projectId: UUID) -> AnyPublisher<UIImage, ServiceError>
    func updateProjectName(id: UUID, name: String) -> AnyPublisher<String, ServiceError>
    func updateProjectDateStarted(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError>
    func updateProjectDateFinished(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError>
}

struct ProjectService: ProjectServiceProtocol {
    private let dataStore: DataStoreProtocol
    private let transformer: ModelTransformer
    
    init(dataStore: DataStoreProtocol = DataStore.shared, transformer: ModelTransformer = ModelTransformer()) {
        self.dataStore = dataStore
        self.transformer = transformer
    }
    
    func getProjects() -> AnyPublisher<[ProjectModel], ServiceError> {
        return Future<[ProjectModel], ServiceError> { promise in
            dataStore.fetchProjects { result in
                switch result {
                case .success(let projectsData):
                    let models = projectsData.map { transformer.model(from: $0) }
                    promise(.success(models))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
        
    func addProject(name: String, imageData: Data?, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<UUID, ServiceError> {
        return Future<UUID, ServiceError> { promise in
            dataStore.add(projectData: AddProjectData(name: name, imageData: imageData, dateStarted: dateStarted, dateFinished: dateFinished)) { result in
                switch result {
                case .success(let id):
                    promise(.success(id))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteProject(id: UUID) -> AnyPublisher<String, ServiceError> {
        return Future<String, ServiceError> { promise in
            dataStore.deleteProject(id: id) { result in
                switch result {
                case .success(let projectName):
                    promise(.success(projectName))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getProject(id: UUID) -> AnyPublisher<ProjectModel, ServiceError> {
        return Future<ProjectModel, ServiceError> { promise in
            dataStore.fetchProject(id: id) { result in
                switch result {
                case .success(let projectData):
                    promise(.success(transformer.model(from: projectData)))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getImage(projectId: UUID) -> AnyPublisher<UIImage, ServiceError> {
        return Future<UIImage, ServiceError> { promise in
            dataStore.fetchImage(id: projectId) { result in
                switch result {
                case .success(let image):
                    promise(.success(image))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    
    func updateProjectName(id: UUID, name: String) -> AnyPublisher<String, ServiceError> {
        return Future<String, ServiceError> { promise in
            dataStore.updateProjectName(id: id, name: name) { result in
                switch result {
                case .success(let updatedName):
                    promise(.success(updatedName))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateProjectDateStarted(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError> {
        return Future<Date, ServiceError> { promise in
            dataStore.updateProjectDateStarted(id: id, date: date) { result in
                switch result {
                case .success(let updatedDate):
                    promise(.success(updatedDate))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateProjectDateFinished(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError> {
        return Future<Date, ServiceError> { promise in
            dataStore.updateProjectDateFinished(id: id, date: date) { result in
                switch result {
                case .success(let updatedDate):
                    promise(.success(updatedDate))
                case .failure:
                    promise(.failure(ServiceError.failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}
