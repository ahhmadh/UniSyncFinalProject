//
//  DashboardViewModel.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var assignments: [Assignment] = []
    @Published var goals: [StudyGoal] = []

    func load() {
        FirebaseManager.shared.fetchCourses { [weak self] courses in
            self?.courses = courses
        }
        FirebaseManager.shared.fetchAssignments { [weak self] assignments in
            self?.assignments = assignments
        }
        FirebaseManager.shared.fetchGoals { [weak self] goals in
            self?.goals = goals
        }
    }

    var pendingAssignments: [Assignment] {
        assignments.filter { !$0.completed }
    }

    var totalHours: Double {
        goals.reduce(0.0) { total, goal in
            total + goal.completedHours
        }
    }
}
