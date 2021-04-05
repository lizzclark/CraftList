//
//  EditDateViewModelTests.swift
//  CraftListTests
//
//  Created by Lizz Clark on 05/04/2021.
//

import XCTest
@testable import CraftList

class EditDateViewModelTests: XCTestCase {

    private var mockedService: MockProjectService!
    private var dateStartedViewModel: EditDateViewModel!
    private var dateFinishedViewModel: EditDateViewModel!

    override func setUp() {
        super.setUp()
        mockedService = MockProjectService()
        dateStartedViewModel = EditDateViewModel(.dateStarted, projectId: UUID(), date: Date(), service: mockedService)
        dateFinishedViewModel = EditDateViewModel(.dateFinished, projectId: UUID(), date: Date(), service: mockedService)
    }
    
    override func tearDown() {
        dateStartedViewModel = nil
        dateFinishedViewModel = nil
        mockedService = nil
        super.tearDown()
    }

    // MARK: - Field
    
    func testField_DateStarted_Strings() {
        XCTAssertEqual(dateStartedViewModel.field.description, "Date Started")
        XCTAssertEqual(dateStartedViewModel.field.title, "Edit Date Started")
    }
    
    func testField_DateFinished_Strings() {
        XCTAssertEqual(dateFinishedViewModel.field.description, "Date Finished")
        XCTAssertEqual(dateFinishedViewModel.field.title, "Edit Date Finished")
    }
    
    // MARK: - Date Started Save
    
    func test_WhenDateStarted_Save_CallsServiceUpdateDateStarted() {
        let expectedDate = Date()
        dateStartedViewModel.date = expectedDate
        
        dateStartedViewModel.save { }
        XCTAssertTrue(mockedService.updateDateStartedCalled)
        XCTAssertEqual(mockedService.capturedProjectId, dateStartedViewModel.projectId)
        XCTAssertEqual(mockedService.capturedDateStarted, expectedDate)
    }
    
    func test_WhenDateStarted_Save_CallsCompletionOnSuccess() {
        mockedService.stubUpdateDateStartedResult = .success(Date())
        
        var completionCalled = false
        dateStartedViewModel.save {
            completionCalled = true
        }
        
        XCTAssertTrue(completionCalled)
    }
    
    // MARK: - Date Finished Save
    
    func test_WhenDateFinished_Save_CallsServiceUpdateDateFinished() {
        let expectedDate = Date()
        dateFinishedViewModel.date = expectedDate
        
        dateFinishedViewModel.save { }
        XCTAssertTrue(mockedService.updateDateFinishedCalled)
        XCTAssertEqual(mockedService.capturedProjectId, dateFinishedViewModel.projectId)
        XCTAssertEqual(mockedService.capturedDateFinished, expectedDate)
    }
    
    func test_WhenDateFinished_Save_CallsCompletionOnSuccess() {
        mockedService.stubUpdateDateFinishedResult = .success(Date())
        
        var completionCalled = false
        dateFinishedViewModel.save {
            completionCalled = true
        }
        
        XCTAssertTrue(completionCalled)
    }

}
