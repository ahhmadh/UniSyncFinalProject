//
//  StudyGoalsViewModel.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import Foundation
import Combine

@MainActor
final class StudyGoalsViewModel: ObservableObject {
    @Published var studyGoals: [StudyGoal] = []
    @Published var availableCourses: [Course] = []

    func loadGoals() {
        FirebaseManager.shared.fetchGoals { [weak self] fetched in
            DispatchQueue.main.async { self?.studyGoals = fetched }
        }
    }

    func updateCourses(_ newCourses: [Course]) {
        availableCourses = newCourses
    }

    func addGoal(title: String, course: Course, targetHours: Double) {
        let newGoal = StudyGoal(
            title: title,
            courseId: course.id,
            targetHours: targetHours,
            completedHours: 0
        )
        studyGoals.append(newGoal)
        FirebaseManager.shared.saveGoal(newGoal)
    }

    func logHours(for goal: StudyGoal, hours: Double) {
        guard let index = studyGoals.firstIndex(where: { $0.id == goal.id }) else { return }
        studyGoals[index].completedHours = min(
            studyGoals[index].completedHours + hours,
            studyGoals[index].targetHours
        )
        FirebaseManager.shared.saveGoal(studyGoals[index])
    }

    func delete(_ goal: StudyGoal) {
        studyGoals.removeAll { $0.id == goal.id }
        FirebaseManager.shared.deleteGoal(goal.id)
    }
}
