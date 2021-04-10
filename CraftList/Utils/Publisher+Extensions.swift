//
//  Publisher+Extensions.swift
//  CraftList
//
//  Created by Lizz Clark on 10/04/2021.
//

import Combine

extension Publisher {
    func ignoreError() -> Publishers.Catch<Self, Empty<Self.Output, Never>> {
        return self.catch { _ in
            return Empty()
        }
    }
}
