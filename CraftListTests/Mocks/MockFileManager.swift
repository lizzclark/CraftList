//
//  MockFileManager.swift
//  CraftListTests
//
//  Created by Lizz Clark on 10/04/2021.
//

import Foundation
@testable import CraftList

final class MockFileManager: FileManagerProtocol {
    var urlForDirectoryCalled = false
    var stubURLForDirectory: URL = URL(string: "https://replace.me")!
    var capturedDirectory: FileManager.SearchPathDirectory?
    var capturedDomain: FileManager.SearchPathDomainMask?
    var capturedURL: URL?
    var capturedShouldCreate: Bool?
    func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL {
        urlForDirectoryCalled = true
        capturedDirectory = directory
        capturedDomain = domain
        capturedURL = url
        capturedShouldCreate = shouldCreate
        return stubURLForDirectory
    }
    
    var createFileCalled = false
    var capturedCreateFilePath: String?
    var capturedContents: Data?
    var capturedAttributes: [FileAttributeKey : Any]?
    var stubCreateFileResult = false
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool {
        createFileCalled = true
        capturedCreateFilePath = path
        capturedContents = data
        capturedAttributes = attr
        return stubCreateFileResult
    }
    
    var setAttributesCalled = false
    var capturedSetAttributesPath: String?
    var capturedSetAttributes: [FileAttributeKey : Any]?
    func setAttributes(_ attributes: [FileAttributeKey : Any], ofItemAtPath path: String) throws {
        setAttributesCalled = true
        capturedSetAttributes = attributes
        capturedSetAttributesPath = path
    }
    
    var fileExistsCalled = false
    var capturedFileExistsPath: String?
    var stubFileExistsResult = false
    func fileExists(atPath path: String) -> Bool {
        fileExistsCalled = true
        capturedFileExistsPath = path
        return stubFileExistsResult
    }
    
    var createDirectoryCalled = false
    var capturedCreateDirectoryPath: String?
    var capturedCreateIntermediates: Bool?
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        createDirectoryCalled = true
        capturedCreateDirectoryPath = path
        capturedCreateIntermediates = createIntermediates
        capturedAttributes = attributes
    }
}
