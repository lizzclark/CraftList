//
//  ImageStorageTests.swift
//  CraftListTests
//
//  Created by Lizz Clark on 10/04/2021.
//

import XCTest
@testable import CraftList
import FileProvider

class ImageStorageTests: XCTestCase {
    
    enum Fixtures {
        static let testData: Data = {
            let image = UIImage(systemName: "video.circle")!
            return image.pngData()!
        }()
        static let name = "Test-Store-Name"
        static let url = URL(string: "my.url/some-dir/test/url")!
    }
    
    private var mockedFileManager: MockFileManager!
    private var imageStorage: ImageStorage!
    
    override func setUp() {
        super.setUp()
        
        mockedFileManager = MockFileManager()
    }
    
    override func tearDown() {
        mockedFileManager = nil
        imageStorage = nil
        
        super.tearDown()
    }
    
    // MARK: - init
    
    func test_onInit_CallsFileManagerURLForDirectory_AndSetsPathByAppendingName() {
        mockedFileManager.stubURLForDirectory = Fixtures.url

        imageStorage = makeStore()!
        XCTAssertTrue(mockedFileManager.urlForDirectoryCalled)
        XCTAssertEqual(mockedFileManager.capturedDirectory, .cachesDirectory)
        XCTAssertEqual(mockedFileManager.capturedDomain, .userDomainMask)
        XCTAssertNil(mockedFileManager.capturedURL)
        XCTAssertTrue(mockedFileManager.capturedShouldCreate ?? false)

        XCTAssertEqual(imageStorage.path, "\(Fixtures.url.absoluteString)/\(Fixtures.name)")
    }
    
    func test_onInit_AndDirectoryDoesNotExist_CreatesDirectory() {
        mockedFileManager.stubURLForDirectory = Fixtures.url
        mockedFileManager.stubFileExistsResult = false
        
        imageStorage = makeStore()!
        
        XCTAssertTrue(mockedFileManager.fileExistsCalled)
        XCTAssertEqual(mockedFileManager.capturedFileExistsPath, "\(Fixtures.url.absoluteString)/Test-Store-Name")
        XCTAssertTrue(mockedFileManager.createDirectoryCalled)
        XCTAssertEqual(mockedFileManager.capturedCreateDirectoryPath, "\(Fixtures.url.absoluteString)/Test-Store-Name")
        XCTAssertTrue(mockedFileManager.capturedCreateIntermediates ?? false)
        XCTAssertNil(mockedFileManager.capturedAttributes)
    }
    
    func test_onInit_AndDirectoryDoesNotExist_SetsProtectionTypeToComplete() {
        mockedFileManager.stubURLForDirectory = Fixtures.url
        mockedFileManager.stubFileExistsResult = false
        
        imageStorage = makeStore()!

        XCTAssertTrue(mockedFileManager.setAttributesCalled)
        XCTAssertEqual(mockedFileManager.capturedSetAttributesPath, "\(Fixtures.url.absoluteString)/Test-Store-Name")
        XCTAssertEqual(mockedFileManager.capturedSetAttributes?[.protectionKey] as? FileProtectionType, FileProtectionType.complete)
    }
    
    func test_onInit_AndDirectoryExists_SetsProtectionTypeToComplete() {
        mockedFileManager.stubURLForDirectory = Fixtures.url
        mockedFileManager.stubFileExistsResult = true
        
        imageStorage = makeStore()!
        XCTAssertEqual(imageStorage.path, "\(Fixtures.url.absoluteString)/Test-Store-Name")

        XCTAssertTrue(mockedFileManager.setAttributesCalled)
        XCTAssertEqual(mockedFileManager.capturedSetAttributesPath, "\(Fixtures.url)/Test-Store-Name")
        XCTAssertEqual(mockedFileManager.capturedSetAttributes?[.protectionKey] as? FileProtectionType, FileProtectionType.complete)
    }

    // MARK: - Set Image Data

    func test_SetImageData_CallsFileManagerCreateFile_WithPathContainingKeyAndStoreName() {
        mockedFileManager.stubURLForDirectory = Fixtures.url

        imageStorage = makeStore()!
        XCTAssertEqual(imageStorage.path, "\(Fixtures.url.absoluteString)/Test-Store-Name")

        
        _ = imageStorage.setImageData(Fixtures.testData, forKey: "my-test-key")
        
        XCTAssertTrue(mockedFileManager.createFileCalled)
        XCTAssertEqual(mockedFileManager.capturedCreateFilePath, "\(Fixtures.url)/Test-Store-Name/my-test-key")
        XCTAssertEqual(mockedFileManager.capturedContents, Fixtures.testData)
        XCTAssertNil(mockedFileManager.capturedAttributes)
    }
    
    func test_SetImageData_ReturnsTrueWhenFileManagerCreatesFile() {
        mockedFileManager.stubCreateFileResult = true
        imageStorage = makeStore()!
        
        let result = imageStorage.setImageData(Fixtures.testData, forKey: "test-key")
        
        XCTAssertTrue(result)
    }
    
    func test_SetImageData_ReturnsFalseWhenFileManagerDoesNotCreateFile() {
        mockedFileManager.stubCreateFileResult = false
        imageStorage = makeStore()!
        
        let result = imageStorage.setImageData(Fixtures.testData, forKey: "test-key")
        
        XCTAssertFalse(result)
    }
    
    // MARK: - Image for Key
    
    func test_ImageForKey_WhenNoImageExistsAtPath_ReturnsNil() {
        imageStorage = makeStore()
        let image = imageStorage.image(forKey: "some-random-key")
        XCTAssertNil(image?.pngData())
    }

    
    func test_ImageForKey_GetsImageAtFilePath() {
        guard let realImageStore = try? ImageStorage(name: Fixtures.name, fileManager: FileProvider.FileManager()) else {
            return XCTFail("couldn't create real image store or file manager")
        }
        
        XCTAssertTrue(realImageStore.setImageData(Fixtures.testData, forKey: "test-key"))
        let image = realImageStore.image(forKey: "test-key")
        XCTAssertNotNil(image?.pngData())
    }
}

private extension ImageStorageTests {
    func makeStore(name: String = Fixtures.name) -> ImageStorage? {
        guard let imageStore = try? ImageStorage(name: name, fileManager: mockedFileManager) else {
            return nil
        }
        return imageStore
    }
}
