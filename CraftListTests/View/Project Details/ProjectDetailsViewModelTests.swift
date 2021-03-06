//
//  ProjectDetailsViewModelTests.swift
//  CraftListTests
//
//  Created by Lizz Clark on 05/04/2021.
//

import XCTest
@testable import CraftList

class ProjectDetailsViewModelTests: XCTestCase {
    
    private var mockedService: MockProjectService!
    private var viewModel: ProjectDetailsViewModel!
    
    private enum Data {
        static let project = ProjectModel(id: UUID(),
                                          name: "Name",
                                          dateStarted: Date(timeIntervalSinceReferenceDate: 2),
                                          dateFinished: Date(timeIntervalSinceReferenceDate: 2))
    }
    
    override func setUp() {
        super.setUp()
        mockedService = MockProjectService()
        viewModel = ProjectDetailsViewModel(id: UUID(), service: mockedService)
    }
    
    override func tearDown() {
        mockedService = nil
        viewModel = nil
        super.tearDown()
    }

    //MARK: - Fetch Project
    
    func test_FetchProject_FetchesDataFromService() {
        viewModel.fetchProject()
        XCTAssertTrue(mockedService.getProjectCalled)
        XCTAssertEqual(mockedService.capturedProjectId, viewModel.id)
    }
    
    func test_FetchProject_OnSuccess_TransformsAndPublishesProject() {
        mockedService.stubGetProjectResult = .success(Data.project)
        
        viewModel.fetchProject()
        let project = viewModel.project
        XCTAssertNotNil(project)
        XCTAssertEqual(project?.name, Data.project.name)
        XCTAssertEqual(project?.dateStarted, Data.project.dateStarted)
        XCTAssertEqual(project?.dateFinished, Data.project.dateFinished)
        XCTAssertEqual(project?.dateStartedText, "1 January 2001")
        XCTAssertEqual(project?.dateFinishedText, "1 January 2001")
    }
    
    // MARK: - Delete Project
    
    func test_DeleteProject_CallsServiceDeleteWithId() {
        let expectedId = UUID()
        viewModel = ProjectDetailsViewModel(id: expectedId, service: mockedService)
        viewModel.deleteProject()
        
        XCTAssertEqual(mockedService.deleteProjectCalledCount, 1)
        XCTAssertEqual(mockedService.capturedDeleteProjectIds.first, expectedId)
    }
    
    func test_DeleteProject_SetsProjectToNilOnSuccess() {
        let expect = expectation(description: #function)
        _ = viewModel.$project
            .sink(receiveValue: { project in
                XCTAssertNil(project)
                expect.fulfill()
            })
        viewModel.deleteProject()
        waitForExpectations(timeout: 0.5)
    }
}
