//
//  StudyGoal.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation

struct StudyGoal: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var title: String
    var courseId: String
    var targetHours: Double
    var completedHours: Double   // <-- required by the ViewModel
}
