//
//  MockProjectService.swift
//  CraftListTests
//
//  Created by Lizz Clark on 05/04/2021.
//

import Foundation
@testable import CraftList
import Combine

final class MockProjectService: ProjectServiceProtocol {
    var stubProjectsResult: Result<[ProjectModel], ServiceError> = .failure(.failure)
    func projects() -> AnyPublisher<[ProjectModel], ServiceError> {
        return stubProjectsResult.publisher.eraseToAnyPublisher()
    }
    
    var stubAddProjectResult: Result<UUID, ServiceError> = .failure(.failure)
    func addProject(name: String, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<UUID, ServiceError> {
        return stubAddProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubDeleteProjectResult: Result<String, ServiceError> = .failure(.failure)
    func deleteProject(id: UUID) -> AnyPublisher<String, ServiceError> {
        return stubDeleteProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubGetProjectResult: Result<ProjectModel, ServiceError> = .failure(.failure)
    func getProject(id: UUID) -> AnyPublisher<ProjectModel, ServiceError> {
        return stubGetProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubUpdateProjectNameResult: Result<String, ServiceError> = .failure(.failure)
    var updateProjectNameCalled = false
    var capturedProjectId: UUID?
    var capturedProjectName: String?
    func updateProjectName(id: UUID, name: String) -> AnyPublisher<String, ServiceError> {
        updateProjectNameCalled = true
        capturedProjectId = id
        capturedProjectName = name
        return stubUpdateProjectNameResult.publisher.eraseToAnyPublisher()
    }
    
    var stubUpdateDateStartedResult: Result<Date, ServiceError> = .failure(.failure)
    func updateProjectDateStarted(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError> {
        return stubUpdateDateStartedResult.publisher.eraseToAnyPublisher()
    }
    
    var stubUpdateDateFinishedResult: Result<Date, ServiceError> = .failure(.failure)
    func updateProjectDateFinished(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError> {
        return stubUpdateDateFinishedResult.publisher.eraseToAnyPublisher()
    }
}
