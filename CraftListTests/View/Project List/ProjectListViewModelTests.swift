//
//  ProjectListViewModelTests.swift
//  CraftListTests
//
//  Created by Lizz Clark on 05/04/2021.
//

import XCTest
@testable import CraftList

class ProjectListViewModelTests: XCTestCase {
    
    private var mockedService: MockProjectService!
    private var viewModel: ProjectListViewModel!
    
    private enum Data {
        static let projects = [
            ProjectModel(id: UUID(), name: "Name", dateStarted: Date(), dateFinished: Date()),
            ProjectModel(id: UUID(), name: "Name 2", dateStarted: Date(), dateFinished: nil)
        ]
    }
    
    override func setUp() {
        super.setUp()
        mockedService = MockProjectService()
        mockedService.stubGetProjectsResult = .success(Data.projects)
        viewModel = ProjectListViewModel(service: mockedService)
    }
    
    override func tearDown() {
        mockedService = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Fetch Projects
    
    func test_FetchProjects_CallsService() {
        viewModel.fetchProjects()
        XCTAssertEqual(mockedService.getProjectsCalledCount, 1)
    }
    
    func test_OnSuccessfulFetch_ItCanTransformAndPublishProjects() {
        viewModel.fetchProjects()
        XCTAssertEqual(viewModel.projects.count, 2)
        let firstProject = viewModel.projects.first
        XCTAssertEqual(firstProject?.id, Data.projects.first?.id)
        XCTAssertEqual(firstProject?.name, Data.projects.first?.name)
        XCTAssertEqual(firstProject?.dateStarted, Data.projects.first?.dateStarted)
        XCTAssertEqual(firstProject?.dateFinished, Data.projects.first?.dateFinished)
        let secondProject = viewModel.projects.last
        XCTAssertEqual(secondProject?.id, Data.projects.last?.id)
        XCTAssertEqual(secondProject?.name, Data.projects.last?.name)
        XCTAssertEqual(secondProject?.dateStarted, Data.projects.last?.dateStarted)
        XCTAssertNil(secondProject?.dateFinished)
    }
    
    // MARK: - Delete Items
    
    func test_DeleteItems_SingleItem_CallsDeleteWithID() {
        viewModel.fetchProjects()
        viewModel.deleteItems(offsets: .init(integer: 1))
        
        XCTAssertEqual(mockedService.deleteProjectCalledCount, 1)
        XCTAssertEqual(mockedService.capturedDeleteProjectIds.first, Data.projects.last?.id)
    }
    
    func test_DeleteItems_MultipleItems_CallsDeleteWithIDs() {
        viewModel.fetchProjects()
        viewModel.deleteItems(offsets: IndexSet([0, 1]))
        
        XCTAssertEqual(mockedService.deleteProjectCalledCount, 2)
        XCTAssertEqual(mockedService.capturedDeleteProjectIds.first, Data.projects.first?.id)
        XCTAssertEqual(mockedService.capturedDeleteProjectIds.last, Data.projects.last?.id)
    }
    
    func test_WhenItemIsDeleted_RefreshesProjects() {
        viewModel.fetchProjects()
        mockedService.stubDeleteProjectResult = .success("Deleted")
        viewModel.deleteItems(offsets: .init(integer: 1))
        
        XCTAssertEqual(mockedService.deleteProjectCalledCount, 1)
        XCTAssertEqual(mockedService.getProjectsCalledCount, 2)
    }

}
