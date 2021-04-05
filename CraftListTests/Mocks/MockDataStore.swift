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
    var fetchProjectsCalled = false
    var stubFetchProjectsResult: Result<[ProjectData], DataStoreError> = .failure(.adding)
    func fetchProjects(completion: (Result<[ProjectData], DataStoreError>) -> Void) {
        fetchProjectsCalled = true
        completion(stubFetchProjectsResult)
    }
    
    var fetchProjectCalled = false
    var capturedFetchProjectId: UUID?
    var stubFetchProjectResult: Result<ProjectData, DataStoreError> = .failure(.fetching)
    func fetchProject(id: UUID, completion: (Result<ProjectData, DataStoreError>) -> Void) {
        fetchProjectCalled = true
        capturedFetchProjectId = id
        completion(stubFetchProjectResult)
    }
    
    var addProjectCalled = false
    var capturedAddProjectData: AddProjectData?
    var stubAddProjectResult: Result<UUID, DataStoreError> = .failure(.adding)
    func add(projectData: AddProjectData, completion: (Result<UUID, DataStoreError>) -> Void) {
        addProjectCalled = true
        capturedAddProjectData = projectData
        completion(stubAddProjectResult)
    }
    
    var deleteProjectCalled = false
    var capturedDeleteProjectId: UUID?
    var stubDeleteProjectResult: Result<String, DataStoreError> = .failure(.deleting)
    func deleteProject(id: UUID, completion: (Result<String, DataStoreError>) -> Void) {
        deleteProjectCalled = true
        capturedDeleteProjectId = id
        completion(stubDeleteProjectResult)
    }
    
    var capturedUpdateProjectId: UUID?
    var capturedUpdateProjectDate: Date?

    var updateProjectNameCalled = false
    var capturedUpdateProjectName: String?
    var stubUpdateProjectNameResult: Result<String, DataStoreError> = .failure(.updating)
    func updateProjectName(id: UUID, name: String, completion: (Result<String, DataStoreError>) -> Void) {
        updateProjectNameCalled = true
        capturedUpdateProjectId = id
        capturedUpdateProjectName = name
        completion(stubUpdateProjectNameResult)
    }
    
    var updateProjectDateStartedCalled = false
    var stubUpdateDateStartedResult: Result<Date, DataStoreError> = .failure(.updating)
    func updateProjectDateStarted(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void) {
        updateProjectDateStartedCalled = true
        capturedUpdateProjectId = id
        capturedUpdateProjectDate = date
        completion(stubUpdateDateStartedResult)
    }
    
    var updateProjectDateFinishedCalled = false
    var stubUpdateDateFinishedResult: Result<Date, DataStoreError> = .failure(.updating)
    func updateProjectDateFinished(id: UUID, date: Date, completion: (Result<Date, DataStoreError>) -> Void) {
        updateProjectDateFinishedCalled = true
        capturedUpdateProjectId = id
        capturedUpdateProjectDate = date
        completion(stubUpdateDateFinishedResult)
    }
}
