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
    
    private var mockedDataStore: MockDataStore!
    private var service: ProjectService!
    
    override func setUp() {
        super.setUp()
        mockedDataStore = MockDataStore()
        service = ProjectService(dataStore: mockedDataStore)
    }
    
    override func tearDown() {
        mockedDataStore = nil
        service = nil
        super.tearDown()
    }
    
    // MARK: - Projects
    
    func testProjects_CallsDataStoreProjects() {
        _ = service.projects()
        
        XCTAssertTrue(self.mockedDataStore.projectsPublisherCalled)
    }
    
    func testProjects_PublishesProjectModelsOnSuccess() {
        let expect = expectation(description: #function)
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
        let expectedDate = Date()
        
        _ = service.addProject(name: "Test", dateStarted: expectedDate, dateFinished: nil)
        
        XCTAssertTrue(self.mockedDataStore.addProjectCalled)
        XCTAssertEqual(self.mockedDataStore.capturedAddProjectData?.name, "Test")
        XCTAssertEqual(self.mockedDataStore.capturedAddProjectData?.dateStarted, expectedDate)
        XCTAssertNil(self.mockedDataStore.capturedAddProjectData?.dateFinished)
    }

    func testAddProject_PublishesIdOnSuccess() {
        let expect = expectation(description: #function)
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
        let expectedId = UUID()
        
        _ = service.getProject(id: expectedId)

        XCTAssertTrue(self.mockedDataStore.fetchProjectCalled)
        XCTAssertEqual(self.mockedDataStore.capturedFetchProjectId, expectedId)
    }

    func testGetProject_PublishesProjectModelOnSuccess() {
        let expect = expectation(description: #function)
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
        let expectedId = UUID()
        
        _ = service.deleteProject(id: expectedId)
        XCTAssertTrue(self.mockedDataStore.deleteProjectCalled)
        XCTAssertEqual(self.mockedDataStore.capturedDeleteProjectId, expectedId)
    }

    func testDeleteProject_PublishesProjectNameOnSuccess() {
        let expect = expectation(description: #function)
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
        let expectedId = UUID()
        
        _ = service.updateProjectName(id: expectedId, name: "Test")
        XCTAssertTrue(self.mockedDataStore.updateProjectNameCalled)
        XCTAssertEqual(self.mockedDataStore.capturedUpdateProjectId, expectedId)
        XCTAssertEqual(self.mockedDataStore.capturedUpdateProjectName, "Test")
    }
    
    func testUpdateProjectName_PublishesProjectNameOnSuccess() {
        let expect = expectation(description: #function)
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
        let expectedId = UUID()
        let expectedDate = Date()
        
        _ = service.updateProjectDateStarted(id: expectedId, date: expectedDate)
        XCTAssertTrue(self.mockedDataStore.updateProjectDateStartedCalled)
        XCTAssertEqual(self.mockedDataStore.capturedUpdateProjectId, expectedId)
        XCTAssertEqual(self.mockedDataStore.capturedUpdateProjectDate, expectedDate)
    }
    
    func testUpdateProjectDateStarted_PublishesProjectDateStartedOnSuccess() {
        let expect = expectation(description: #function)
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
        let expectedId = UUID()
        let expectedDate = Date()
        
        _ = service.updateProjectDateFinished(id: expectedId, date: expectedDate)
        XCTAssertTrue(self.mockedDataStore.updateProjectDateFinishedCalled)
        XCTAssertEqual(self.mockedDataStore.capturedUpdateProjectId, expectedId)
        XCTAssertEqual(self.mockedDataStore.capturedUpdateProjectDate, expectedDate)
    }

    
    func testUpdateProjectDateFinished_PublishesProjectDateFinishedOnSuccess() {
        let expect = expectation(description: #function)
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
