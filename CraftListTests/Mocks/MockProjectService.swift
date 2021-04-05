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
    var capturedProjectId: UUID?

    var stubProjectsResult: Result<[ProjectModel], ServiceError> = .failure(.failure)
    func projects() -> AnyPublisher<[ProjectModel], ServiceError> {
        return stubProjectsResult.publisher.eraseToAnyPublisher()
    }
    
    var stubAddProjectResult: Result<UUID, ServiceError> = .failure(.failure)
    func addProject(name: String, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<UUID, ServiceError> {
        return stubAddProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubDeleteProjectResult: Result<String, ServiceError> = .failure(.failure)
    var deleteProjectCalled = false
    func deleteProject(id: UUID) -> AnyPublisher<String, ServiceError> {
        deleteProjectCalled = true
        capturedProjectId = id
        return stubDeleteProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubGetProjectResult: Result<ProjectModel, ServiceError> = .failure(.failure)
    var getProjectCalled = false
    func getProject(id: UUID) -> AnyPublisher<ProjectModel, ServiceError> {
        getProjectCalled = true
        capturedProjectId = id
        return stubGetProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubUpdateProjectNameResult: Result<String, ServiceError> = .failure(.failure)
    var updateProjectNameCalled = false
    var capturedProjectName: String?
    func updateProjectName(id: UUID, name: String) -> AnyPublisher<String, ServiceError> {
        updateProjectNameCalled = true
        capturedProjectId = id
        capturedProjectName = name
        return stubUpdateProjectNameResult.publisher.eraseToAnyPublisher()
    }
    
    var stubUpdateDateStartedResult: Result<Date, ServiceError> = .failure(.failure)
    var updateDateStartedCalled = false
    var capturedDateStarted: Date?
    func updateProjectDateStarted(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError> {
        updateDateStartedCalled = true
        capturedProjectId = id
        capturedDateStarted = date
        return stubUpdateDateStartedResult.publisher.eraseToAnyPublisher()
    }
    
    var stubUpdateDateFinishedResult: Result<Date, ServiceError> = .failure(.failure)
    var updateDateFinishedCalled = false
    var capturedDateFinished: Date?
    func updateProjectDateFinished(id: UUID, date: Date) -> AnyPublisher<Date, ServiceError> {
        updateDateFinishedCalled = true
        capturedProjectId = id
        capturedDateFinished = date
        return stubUpdateDateFinishedResult.publisher.eraseToAnyPublisher()
    }
}
