//
//  MockDataStore.swift
//  MockDataStore
//
//  Created by Lizz Clark on 02/04/2021.
//

import XCTest
@testable import CraftList
import Combine

final class MockDataStore: DataStoreProtocol {
    var stubError: DataStoreError?
    
    var projectsPublisherCalled = false
    var stubProjectsPublisherData: [ProjectData]?
    func projectsPublisher() -> AnyPublisher<[ProjectData], DataStoreError> {
        projectsPublisherCalled = true
        
        var result: Result<[ProjectData], DataStoreError> = .failure(.adding)
        if let projects = stubProjectsPublisherData {
            result = .success(projects)
        } else if let error = stubError {
            result = .failure(error)
        }
        return result.publisher.eraseToAnyPublisher()
    }
    
    var fetchProjectCalled = false
    var capturedFetchProjectId: UUID?
    var stubFetchProjectData: ProjectData?
    func fetchProject(id: UUID, completion: (Result<ProjectData, DataStoreError>) -> Void) {
        fetchProjectCalled = true
        capturedFetchProjectId = id
        if let error = stubError {
            completion(.failure(error))
        } else if let data = stubFetchProjectData {
            completion(.success(data))
        }
    }
    
    var addProjectCalled = false
    var capturedAddProjectData: AddProjectData?
    func add(projectData: AddProjectData, completion: (Result<UUID, DataStoreError>) -> Void) {
        addProjectCalled = true
        capturedAddProjectData = projectData
        
        if let error = stubError {
            completion(.failure(error))
        } else {
            completion(.success(UUID()))
        }
    }
    
    var deleteProjectCalled = false
    var capturedDeleteProjectId: UUID?
    var stubDeletedProjectName: String?
    func deleteProject(id: UUID, completion: (Result<String, DataStoreError>) -> Void) {
        deleteProjectCalled = true
        capturedDeleteProjectId = id
        
        if let error = stubError {
            completion(.failure(error))
        } else if let stubName = stubDeletedProjectName {
            completion(.success(stubName))
        }
    }
    
    var capturedUpdateProjectId: UUID?
    var capturedUpdateProjectDate: Date?

    var updateProjectNameCalled = false
    var capturedUpdateProjectName: String?
    func updateProjectName(id: UUID, name: String, completion: (Result<String, DataStoreError>) -> Void) {
        updateProjectNameCalled = true
        capturedUpdateProjectId = id
        capturedUpdateProjectName = name
        if let error = stubError {
            completion(.failure(error))
        } else {
            completion(.success(name))
        }
    }
    
    var updateProjectDateStartedCalled = false
    func updateProjectDateStarted(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void) {
        updateProjectDateStartedCalled = true
        capturedUpdateProjectId = id
        capturedUpdateProjectDate = date
        if let error = stubError {
            completion(.failure(error))
        } else {
            completion(.success(date))
        }
    }
    
    var updateProjectDateFinishedCalled = false
    func updateProjectDateFinished(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void) {
        updateProjectDateFinishedCalled = true
        capturedUpdateProjectId = id
        capturedUpdateProjectDate = date
        if let error = stubError {
            completion(.failure(error))
        } else {
            completion(.success(date))
        }
    }
}
