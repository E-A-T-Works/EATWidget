//
//  Formatters.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation

extension URL {
    var formatted: String {
        (host ?? "").replacingOccurrences(of: "www.", with: "")
    }
}

extension Date {
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
