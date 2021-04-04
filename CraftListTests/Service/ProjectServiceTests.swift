//
//  ProjectServiceTests.swift
//  ProjectServiceTests
//
//  Created by Lizz Clark on 04/04/2021.
//

import XCTest
@testable import CraftList
import Combine

class ProjectServiceTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    private enum Data {
        static let projects = [
            ProjectData(id: UUID(),
                        name: "Name 1",
                        dateStarted: Date(),
                        dateFinished: Date()),
            ProjectData(id: UUID(),
                        name: "Name 2",
                        dateStarted: Date(),
                        dateFinished: Date())
        ]
        static let project = ProjectData(id: UUID(),
                                         name: "Name",
                                         dateStarted: Date(),
                                         dateFinished: nil)
    }
    
    // MARK: - Projects
    
    func testProjects_PublishesProjectModelsOnSuccess() {
        let expect = expectation(description: "Should fetch projects")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubProjectsPublisherData = Data.projects
        
        service.projects()
            .sink(receiveCompletion: { _ in }) { models in
                XCTAssertTrue(mockedDataStore.projectsPublisherCalled)
                XCTAssertEqual(models.count, 2)
                XCTAssertEqual(models.first?.name, Data.projects[0].name)
                XCTAssertEqual(models.first?.id, Data.projects[0].id)
                XCTAssertEqual(models.first?.dateStarted, Data.projects[0].dateStarted)
                XCTAssertEqual(models.first?.dateFinished, Data.projects[0].dateFinished)
                XCTAssertEqual(models.last?.name, Data.projects[1].name)
                XCTAssertEqual(models.last?.id, Data.projects[1].id)
                XCTAssertEqual(models.last?.dateStarted, Data.projects[1].dateStarted)
                XCTAssertEqual(models.last?.dateFinished, Data.projects[1].dateFinished)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testProjects_PublishesError() {
        let expect = expectation(description: "Should publish error")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubError = DataStoreError.fetching
        
        service.projects()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTAssertTrue(mockedDataStore.projectsPublisherCalled)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Add Project
    
    func testAddProject_CallsDataStoreWithCorrectProjectData_AndPublishesIdOnSuccess() {
        let expect = expectation(description: "Should add project")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedDate = Date()
        
        service.addProject(name: "Test", dateStarted: expectedDate, dateFinished: nil)
            .sink(receiveCompletion: { _ in }) { id in
                XCTAssertTrue(mockedDataStore.addProjectCalled)
                XCTAssertEqual(mockedDataStore.capturedAddProjectData?.name, "Test")
                XCTAssertEqual(mockedDataStore.capturedAddProjectData?.dateStarted, expectedDate)
                XCTAssertNil(mockedDataStore.capturedAddProjectData?.dateFinished)
                XCTAssertFalse(id.isEmpty)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testAddProject_PublishesError() {
        let expect = expectation(description: "Should publish error")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubError = DataStoreError.adding
        let expectedDate = Date()
        
        service.addProject(name: "Test", dateStarted: expectedDate, dateFinished: nil)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTAssertTrue(mockedDataStore.addProjectCalled)
                    XCTAssertEqual(mockedDataStore.capturedAddProjectData?.name, "Test")
                    XCTAssertEqual(mockedDataStore.capturedAddProjectData?.dateStarted, expectedDate)
                    XCTAssertNil(mockedDataStore.capturedAddProjectData?.dateFinished)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }

    // MARK: - Get Project
    
    func testGetProject_PublishesProjectModelOnSuccess() {
        let expect = expectation(description: "Should fetch project")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubFetchProjectData = Data.project
        let expectedId = UUID()

        service.getProject(id: expectedId)
            .sink(receiveCompletion: { _ in }) { model in
                XCTAssertTrue(mockedDataStore.fetchProjectCalled)
                XCTAssertEqual(mockedDataStore.capturedFetchProjectId, expectedId)
                XCTAssertEqual(model.id, Data.project.id)
                XCTAssertEqual(model.name, Data.project.name)
                XCTAssertEqual(model.dateStarted, Data.project.dateStarted)
                XCTAssertNil(model.dateFinished)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testGetProject_PublishesError() {
        let expect = expectation(description: "Should publish error")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubError = DataStoreError.fetching
        let expectedId = UUID()

        service.getProject(id: expectedId)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTAssertEqual(mockedDataStore.capturedFetchProjectId, expectedId)
                    XCTAssertTrue(mockedDataStore.fetchProjectCalled)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Delete Project
    
    func testDeleteProject_PublishesProjectNameOnSuccess() {
        let expect = expectation(description: "Should delete project")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubDeletedProjectName = "Deleted project"
        let expectedId = UUID()

        service.deleteProject(id: expectedId)
            .sink(receiveCompletion: { _ in }) { name in
                XCTAssertTrue(mockedDataStore.deleteProjectCalled)
                XCTAssertEqual(mockedDataStore.capturedDeleteProjectId, expectedId)
                XCTAssertEqual(name, "Deleted project")
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testDeleteProject_PublishesError() {
        let expect = expectation(description: "Should publish error")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubError = DataStoreError.deleting
        let expectedId = UUID()
        
        service.deleteProject(id: expectedId)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertTrue(mockedDataStore.deleteProjectCalled)
                    XCTAssertEqual(mockedDataStore.capturedDeleteProjectId, expectedId)
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Update Project Name
    
    func testUpdateProjectName_PublishesProjectNameOnSuccess() {
        let expect = expectation(description: "Should update project name")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedId = UUID()
        
        service.updateProjectName(id: expectedId, name: "New Name")
            .sink(receiveCompletion: { _ in }) { name in
                XCTAssertTrue(mockedDataStore.updateProjectNameCalled)
                XCTAssertEqual(mockedDataStore.capturedUpdateProjectId, expectedId)
                XCTAssertEqual(name, "New Name")
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testUpdateProjectName_PublishesError() {
        let expect = expectation(description: "Should publish error")
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubError = DataStoreError.fetching
        let expectedId = UUID()
        
        service.updateProjectName(id: expectedId, name: "Test")
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTAssertTrue(mockedDataStore.updateProjectNameCalled)
                    XCTAssertEqual(mockedDataStore.capturedUpdateProjectId, expectedId)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }

}
