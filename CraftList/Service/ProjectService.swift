//
//  ProjectService.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation
import Combine

struct ProjectModel {
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
                    return ProjectModel(name: projectData.name, dateStarted: projectData.dateStarted, dateFinished: projectData.dateFinished)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func addProject(name: String, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<ProjectModel, Never> {
        return Future<ProjectModel, Never> { promise in
            dataStore.add(projectData: ProjectData(name: name, dateStarted: dateStarted, dateFinished: dateFinished)) {
                promise(.success(ProjectModel(name: name, dateStarted: dateStarted, dateFinished: dateFinished)))
            }
        }
        .eraseToAnyPublisher()
    }
    
//    func deleteProject(id: String) -> AnyPublisher<String, Never> {
//        return Future<ProjectModel, Never> { promise in
//            dataStore.deleteProject(id: id) {
//                promise(.success(id))
//            }
//        }
//        .eraseToAnyPublisher()
//    }
}
