//
//  DateFormatter+Extensions.swift
//  CraftList
//
//  Created by Lizz Clark on 03/04/2021.
//

import Foundation

extension DateFormatter {
    static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
