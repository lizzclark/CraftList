//
//  MockImageStorage.swift
//  CraftListTests
//
//  Created by Lizz Clark on 10/04/2021.
//

import Foundation
@testable import CraftList
import UIKit

final class MockImageStorage: ImageStorageProtocol {
    var stubSetImageDataResult: Bool = false
    var setImageDataCalled = false
    var capturedImageData: Data?
    var capturedKey: String?
    func setImageData(_ data: Data, forKey key: String) -> Bool {
        setImageDataCalled = true
        capturedImageData = data
        capturedKey = key
        return stubSetImageDataResult
    }
    
    var stubImageForKey: UIImage?
    var imageForKeyCalled = false
    func image(forKey key: String) -> UIImage? {
        imageForKeyCalled = true
        capturedKey = key
        return stubImageForKey
    }
}

