//
//  ImageStorage.swift
//  CraftList
//
//  Created by Lizz Clark on 10/04/2021.
//

import Foundation
import FileProvider
import UIKit

typealias FileManager = FileProvider.FileManager

protocol ImageStorageProtocol {
    func setImageData(_ data: Data, forKey key: String) -> Bool
    func image(forKey key: String) -> UIImage?
}

final class ImageStorage: ImageStorageProtocol {
    
    static let `default`: ImageStorage = {
        return try! ImageStorage(name: "craftlist")
    }()
    
    private let fileManager: FileManagerProtocol
    private(set) var path: String

    init(name: String,
         fileManager: FileManagerProtocol = FileManager()) throws {
        self.fileManager = fileManager

        let url = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let path = url.appendingPathComponent(name, isDirectory: true).path
        self.path = path
        
        try createDirectory()
        try setDirectoryAttributes([.protectionKey: FileProtectionType.complete])
    }
    
    func setImageData(_ data: Data, forKey key: String) -> Bool {
        let filePath = makeFilePath(for: key)
        return fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    func image(forKey key: String) -> UIImage? {
        let filePath = makeFilePath(for: key)
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)), let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}

private extension ImageStorage {

    func setDirectoryAttributes(_ attributes: [FileAttributeKey: Any]) throws {
        try fileManager.setAttributes(attributes, ofItemAtPath: path)
    }
    
    func makeFileName(for key: String) -> String {
        let fileExtension = URL(fileURLWithPath: key).pathExtension
        return fileExtension.isEmpty ? key : "\(key).\(fileExtension)"
    }

    func makeFilePath(for key: String) -> String {
        return "\(path)/\(makeFileName(for: key))"
    }
    
    func createDirectory() throws {
        guard !fileManager.fileExists(atPath: path) else {
            return
        }
        
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
}

protocol FileManagerProtocol {
    func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool
    func setAttributes(_ attributes: [FileAttributeKey : Any], ofItemAtPath path: String) throws
    func fileExists(atPath path: String) -> Bool
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
}

extension FileManager: FileManagerProtocol { }
