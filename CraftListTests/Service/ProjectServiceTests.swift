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
    
    func testProjects_CallsDataStoreProjects() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        
        service.projects()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    XCTAssertTrue(mockedDataStore.projectsPublisherCalled)
                    expect.fulfill()
                case .finished:
                    break
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testProjects_PublishesProjectModelsOnSuccess() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubProjectsPublisherResult = .success(Data.projects)
        
        service.projects()
            .sink(receiveCompletion: { _ in }) { models in
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
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubProjectsPublisherResult = .failure(.fetching)
        
        service.projects()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Add Project
    
    func testAddProject_CallsDataStoreWithCorrectProjectData() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedDate = Date()
        
        service.addProject(name: "Test", dateStarted: expectedDate, dateFinished: nil)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    XCTAssertTrue(mockedDataStore.addProjectCalled)
                    XCTAssertEqual(mockedDataStore.capturedAddProjectData?.name, "Test")
                    XCTAssertEqual(mockedDataStore.capturedAddProjectData?.dateStarted, expectedDate)
                    XCTAssertNil(mockedDataStore.capturedAddProjectData?.dateFinished)
                    expect.fulfill()
                case .finished:
                    break
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }

    func testAddProject_PublishesIdOnSuccess() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedId = UUID()
        mockedDataStore.stubAddProjectResult = .success(expectedId)
        
        service.addProject(name: "Test", dateStarted: Date(), dateFinished: nil)
            .sink(receiveCompletion: { _ in }) { id in
                XCTAssertEqual(id, expectedId)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testAddProject_PublishesError() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubAddProjectResult = .failure(.adding)
        
        service.addProject(name: "Test", dateStarted: Date(), dateFinished: nil)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Get Project
    
    func testGetProject_CallsDataStoreWithId() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedId = UUID()
        
        service.getProject(id: expectedId)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(mockedDataStore.fetchProjectCalled)
                    XCTAssertEqual(mockedDataStore.capturedFetchProjectId, expectedId)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }

    func testGetProject_PublishesProjectModelOnSuccess() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubFetchProjectResult = .success(Data.project)
        
        service.getProject(id: UUID())
            .sink(receiveCompletion: { _ in }) { model in
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
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubFetchProjectResult = .failure(.fetching)
        
        service.getProject(id: UUID())
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Delete Project
    
    func testDeleteProject_CallsDataStoreWithProjectId() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedId = UUID()
        
        service.deleteProject(id: expectedId)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(mockedDataStore.deleteProjectCalled)
                    XCTAssertEqual(mockedDataStore.capturedDeleteProjectId, expectedId)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }

    func testDeleteProject_PublishesProjectNameOnSuccess() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubDeleteProjectResult = .success("Deleted project")
        
        service.deleteProject(id: UUID())
            .sink(receiveCompletion: { _ in }) { name in
                XCTAssertEqual(name, "Deleted project")
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testDeleteProject_PublishesError() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubDeleteProjectResult = .failure(.deleting)
        
        service.deleteProject(id: UUID())
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Update Project Name
    
    func testUpdateProjectName_CallsDataStoreWithIdAndName() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedId = UUID()
        
        service.updateProjectName(id: expectedId, name: "Test")
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(mockedDataStore.updateProjectNameCalled)
                    XCTAssertEqual(mockedDataStore.capturedUpdateProjectId, expectedId)
                    XCTAssertEqual(mockedDataStore.capturedUpdateProjectName, "Test")
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }

    
    func testUpdateProjectName_PublishesProjectNameOnSuccess() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubUpdateProjectNameResult = .success("New Name")
        
        service.updateProjectName(id: UUID(), name: "Test")
            .sink(receiveCompletion: { _ in }) { name in
                XCTAssertEqual(name, "New Name")
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testUpdateProjectName_PublishesError() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubUpdateProjectNameResult = .failure(.updating)
        
        service.updateProjectName(id: UUID(), name: "Test")
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Update Project Date Started
    
    func testUpdateProjectDateStarted_CallsDataStoreWithIdAndDate() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedId = UUID()
        let expectedDate = Date()
        
        service.updateProjectDateStarted(id: expectedId, date: expectedDate)
            .sink(receiveCompletion: { result in
                XCTAssertTrue(mockedDataStore.updateProjectDateStartedCalled)
                XCTAssertEqual(mockedDataStore.capturedUpdateProjectId, expectedId)
                XCTAssertEqual(mockedDataStore.capturedUpdateProjectDate, expectedDate)
                expect.fulfill()
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testUpdateProjectDateStarted_PublishesProjectDateStartedOnSuccess() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedDate = Date()
        mockedDataStore.stubUpdateDateStartedResult = .success(expectedDate)
        
        service.updateProjectDateStarted(id: UUID(), date: expectedDate)
            .sink(receiveCompletion: { _ in }) { date in
                XCTAssertEqual(date, expectedDate)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testUpdateProjectDateStarted_PublishesError() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubUpdateDateStartedResult = .failure(.updating)
        
        service.updateProjectDateStarted(id: UUID(), date: Date())
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - Update Project Date Finished
    
    func testUpdateProjectDateFinished_CallsDataStoreWithProjectIDAndDate() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedId = UUID()
        let expectedDate = Date()
        
        service.updateProjectDateFinished(id: expectedId, date: expectedDate)
            .sink(receiveCompletion: { _ in
                XCTAssertTrue(mockedDataStore.updateProjectDateFinishedCalled)
                XCTAssertEqual(mockedDataStore.capturedUpdateProjectId, expectedId)
                XCTAssertEqual(mockedDataStore.capturedUpdateProjectDate, expectedDate)
                expect.fulfill()
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }

    
    func testUpdateProjectDateFinished_PublishesProjectDateFinishedOnSuccess() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        let expectedDate = Date()
        mockedDataStore.stubUpdateDateFinishedResult = .success(expectedDate)
        
        service.updateProjectDateFinished(id: UUID(), date: expectedDate)
            .sink(receiveCompletion: { _ in }) { date in
                XCTAssertEqual(date, expectedDate)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testUpdateProjectDateFinished_PublishesError() {
        let expect = expectation(description: #function)
        let mockedDataStore = MockDataStore()
        let service = ProjectService(dataStore: mockedDataStore)
        mockedDataStore.stubUpdateDateStartedResult = .failure(.updating)
        
        service.updateProjectDateFinished(id: UUID(), date: Date())
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expect.fulfill()
                }
            }) { _ in }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5)
    }
}
