//
//  DataStoreTests.swift
//  CraftListTests
//
//  Created by Lizz Clark on 10/04/2021.
//

import XCTest
@testable import CraftList

class DataStoreTests: XCTestCase {
    
    private var mockedImageStore: MockImageStorage!
    private var dataStore: DataStore!
    
    enum TestData {
        static let imageData: Data = {
            let image = UIImage(systemName: "trash.fill")!
            return image.pngData()!
        }()
    }
    
    override func setUp() {
        super.setUp()
        
        mockedImageStore = MockImageStorage()
        dataStore = DataStore(managedObjectContext: PersistenceController.shared.container.viewContext, transformer: DataTransformer(), imageStore: mockedImageStore)
    }
    
    override func tearDown() {
        mockedImageStore = nil
        dataStore = nil
        
        super.tearDown()
    }
    
    // MARK: - Fetch Image

    func testFetchImageCallsImageStorageWithProjectId_UUIDString() {
        let expect = expectation(description: #function)
        
        let expectedId = UUID()
        
        dataStore.fetchImage(id: expectedId) { _ in
            XCTAssertTrue(self.mockedImageStore.imageForKeyCalled)
            XCTAssertEqual(self.mockedImageStore.capturedKey, expectedId.uuidString)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testFetchImage_WhenImageStoreHasImage_CompletesWithSuccess() {
        let expectedImage = UIImage(systemName: "cloud.sun")!
        mockedImageStore.stubImageForKey = expectedImage
        
        var capturedResult: Result<UIImage, DataStoreError>?
        
        dataStore.fetchImage(id: UUID()) { result in
            capturedResult = result
        }
        
        guard case .success(let image) = capturedResult else {
            return XCTFail("expected success result")
        }
        XCTAssertEqual(image, expectedImage)
    }
    
    func testFetchImage_WhenImageStoreHasNoImage_CompletesWithFailure() {
        mockedImageStore.stubImageForKey = nil
        
        var capturedResult: Result<UIImage, DataStoreError>?
        
        dataStore.fetchImage(id: UUID()) { result in
            capturedResult = result
        }
        
        guard case .failure(let error) = capturedResult else {
            return XCTFail("expected failure result")
        }
        guard case DataStoreError.fetching = error else {
            return XCTFail("error should be .fetching")
        }
    }
    
    // MARK: - Add
    
    func test_Add_WhenAddProjectDataHasImage_CallsImageStoreSetImageData() {
        let expect = expectation(description: #function)
        
        let addProjectData = AddProjectData(name: "", imageData: TestData.imageData, dateStarted: Date(), dateFinished: nil)
        
        dataStore.add(projectData: addProjectData) { _ in
            XCTAssertTrue(mockedImageStore.setImageDataCalled)
            XCTAssertEqual(mockedImageStore.capturedImageData, TestData.imageData)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5)
    }
    
    func test_Add_WhenAddProjectDataHasNoImage_DoesNotCallImageStore() {
        let expect = expectation(description: #function)
        
        let addProjectData = AddProjectData(name: "", imageData: nil, dateStarted: Date(), dateFinished: nil)
        
        dataStore.add(projectData: addProjectData) { _ in
            XCTAssertFalse(mockedImageStore.setImageDataCalled)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5)
    }
    
    func test_AddWithImageData_WhenSuccessfullyAddsImageAndStoresProject_ImageKeyIsProjectId() {
        let addProjectData = AddProjectData(name: "", imageData: TestData.imageData, dateStarted: Date(), dateFinished: nil)
        mockedImageStore.stubSetImageDataResult = true
        
        var capturedResult: Result<UUID, DataStoreError>?
        
        dataStore.add(projectData: addProjectData) { result in
            capturedResult = result
        }
        
        guard case .success(let uuid) = capturedResult else {
            return XCTFail("expected success result")
        }
        
        XCTAssertEqual(mockedImageStore.capturedKey, uuid.uuidString)
    }
    
    func test_AddWithImageData_WhenFailsToAddImage_CompletesWithFailure() {
        let addProjectData = AddProjectData(name: "", imageData: TestData.imageData, dateStarted: Date(), dateFinished: nil)
        mockedImageStore.stubSetImageDataResult = false
        
        var capturedResult: Result<UUID, DataStoreError>?
        
        dataStore.add(projectData: addProjectData) { result in
            capturedResult = result
        }
        
        guard case .failure(let error) = capturedResult else {
            return XCTFail("expected success result")
        }
        
        guard case DataStoreError.adding = error else {
            return XCTFail("expected .adding error")
        }
    }

}
