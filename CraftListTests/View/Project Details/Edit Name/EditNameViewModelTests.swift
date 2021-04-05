//
//  EditNameViewModelTests.swift
//  CraftListTests
//
//  Created by Lizz Clark on 05/04/2021.
//

import XCTest
@testable import CraftList
import Combine

class EditNameViewModelTests: XCTestCase {
    
    private var mockedService: MockProjectService!
    private var viewModel: EditNameViewModel!
    
    override func setUp() {
        super.setUp()
        mockedService = MockProjectService()
        viewModel = EditNameViewModel(projectId: UUID(), name: "Project name", service: mockedService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockedService = nil
        super.tearDown()
    }

    func testSaveCallsServiceUpdateWithCorrectData() {
        viewModel.name = "New name"
        viewModel.save { }
        XCTAssertTrue(self.mockedService.updateProjectNameCalled)
        XCTAssertEqual(self.mockedService.capturedProjectName, "New name")
        XCTAssertEqual(self.mockedService.capturedProjectId, self.viewModel.projectId)
    }
    
    func testSaveCallsCompletionOnSuccess() {
        mockedService.stubUpdateProjectNameResult = .success("New name")
        
        var completionCalled = false
        viewModel.save {
            completionCalled = true
        }
        XCTAssertTrue(completionCalled)
    }
}
