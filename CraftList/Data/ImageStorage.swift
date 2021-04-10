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

enum ImageError: Error {
    case invalid
}

protocol ImageStorageProtocol {
    func setImageData(_ data: Data, forKey key: String) -> Bool
    func image(forKey key: String) -> UIImage?
}

final class ImageStorage: ImageStorageProtocol {
    
    static let `default`: ImageStorage = {
        return try! ImageStorage(name: "craftlist")
    }()
    
    private let fileManager: FileManager
    private let path: String

    init(name: String, fileManager: FileManager = FileManager()) throws {
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

