//
//  Assignment.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation

enum Priority: String, Codable, CaseIterable, Identifiable {
    case low, medium, high
    var id: String { rawValue }
}

struct Assignment: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var title: String
    var courseId: String
    var dueDate: Date
    var notes: String
    var completed: Bool
    var priority: Priority
}
