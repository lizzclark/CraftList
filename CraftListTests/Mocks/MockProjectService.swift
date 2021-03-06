//
//  MockProjectService.swift
//  CraftListTests
//
//  Created by Lizz Clark on 05/04/2021.
//

import Foundation
@testable import CraftList
import UIKit
import Combine

final class MockProjectService: ProjectServiceProtocol {
    var capturedProjectId: UUID?

    var stubGetProjectsResult: Result<[ProjectModel], ServiceError> = .failure(.failure)
    var getProjectsCalledCount = 0
    func getProjects() -> AnyPublisher<[ProjectModel], ServiceError> {
        getProjectsCalledCount += 1
        return stubGetProjectsResult.publisher.eraseToAnyPublisher()
    }
    
    var stubAddProjectResult: Result<UUID, ServiceError> = .failure(.failure)
    var addProjectCalled = false
    var capturedAddProjectName: String?
    var capturedAddImageData: Data?
    var capturedAddProjectDateStarted: Date?
    var capturedAddProjectDateFinished: Date?
    func addProject(name: String, imageData: Data?, dateStarted: Date, dateFinished: Date?) -> AnyPublisher<UUID, ServiceError> {
        addProjectCalled = true
        capturedAddProjectName = name
        capturedAddImageData = imageData
        capturedAddProjectDateStarted = dateStarted
        capturedAddProjectDateFinished = dateFinished
        return stubAddProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubDeleteProjectResult: Result<String, ServiceError> = .failure(.failure)
    var deleteProjectCalledCount = 0
    var capturedDeleteProjectIds = [UUID]()
    func deleteProject(id: UUID) -> AnyPublisher<String, ServiceError> {
        deleteProjectCalledCount += 1
        capturedDeleteProjectIds.append(id)
        return stubDeleteProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubGetProjectResult: Result<ProjectModel, ServiceError> = .failure(.failure)
    var getProjectCalled = false
    func getProject(id: UUID) -> AnyPublisher<ProjectModel, ServiceError> {
        getProjectCalled = true
        capturedProjectId = id
        return stubGetProjectResult.publisher.eraseToAnyPublisher()
    }
    
    var stubGetImageResult: Result<UIImage, ServiceError> = .failure(.failure)
    func getImage(projectId: UUID) -> AnyPublisher<UIImage, ServiceError> {
        capturedProjectId = projectId
        return stubGetImageResult.publisher.eraseToAnyPublisher()
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
