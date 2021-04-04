//
//  ProjectService.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation
import Combine

enum ServiceError: Error {
    case failure
}

struct ProjectService {
    private let dataStore: DataStoreProtocol
    
    init(dataStore: DataStoreProtocol = DataStore.shared) {
        self.dataStore = dataStore
    }
    
    func projects() -> AnyPublisher<[ProjectModel], ServiceError> {
        return dataStore
            .projectsPublisher()
            .map({ data in
                return data.map { projectData in
                    return ProjectModel(id: projectData.id, name: projectData.name, dateStarted: projectData.dateStarted, dateFinished: projectData.dateFinished)
                }
            })
            .mapError({ _ in
                return ServiceError.failure
            })
            .eraseToAnyPublisher()
    }
        
    func addProject(name: String, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<String, ServiceError> {
        return Future<String, ServiceError> { promise in
            dataStore.add(projectData: AddProjectData(name: name, dateStarted: dateStarted, dateFinished: dateFinished)) { result in
                switch result {
                case .success:
                    promise(.success(name))
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
                    let model = ProjectModel(id: projectData.id, name: projectData.name, dateStarted: projectData.dateStarted, dateFinished: projectData.dateFinished)
                    promise(.success(model))
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
