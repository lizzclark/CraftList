//
//  AddProjectViewModelTests.swift
//  CraftListTests
//
//  Created by Lizz Clark on 05/04/2021.
//

import XCTest
@testable import CraftList

class AddProjectViewModelTests: XCTestCase {
    
    private var mockedService: MockProjectService!
    private var viewModel: AddProjectViewModel!
    
    override func setUp() {
        super.setUp()
        mockedService = MockProjectService()
        viewModel = AddProjectViewModel(service: mockedService)
    }
    
    override func tearDown() {
        mockedService = nil
        super.tearDown()
    }

    func testSaveCallsServiceAddProject() {
        viewModel.save { }
        XCTAssertTrue(mockedService.addProjectCalled)
    }
    
    func testSave_WhenProjectIsntFinished_SendsCorrectValues() {
        viewModel.name = "New name"
        let expectedDate = Date()
        viewModel.dateStarted = expectedDate

        viewModel.save { }
        XCTAssertEqual(mockedService.capturedAddProjectName, "New name")
        XCTAssertEqual(mockedService.capturedAddProjectDateStarted, expectedDate)
        XCTAssertNil(mockedService.capturedAddProjectDateFinished)
    }
    
    func testSave_WhenProjectIsFinished_SendsFinishDate() {
        viewModel.isFinished = true
        let expectedDate = Date()
        viewModel.dateFinishedFieldValue = expectedDate
        
        viewModel.save { }
        XCTAssertEqual(mockedService.capturedAddProjectDateFinished, expectedDate)
    }
    
    func testSave_WhenImageIsSupplied_SendsImagePNGData() {
        let expectedImage = UIImage(systemName: "cloud.sun")
        viewModel.image = expectedImage
        
        viewModel.save { }
        XCTAssertEqual(mockedService.capturedAddImageData, expectedImage?.pngData())
    }
    
    func testSave_CallsCompletionOnSuccess() {
        mockedService.stubAddProjectResult = .success(UUID())
        var completionCalled = false
        viewModel.save {
            completionCalled = true
        }
        XCTAssertTrue(completionCalled)
    }
}
