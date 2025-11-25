//
//  AssignmentsViewModel.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import Foundation
import Combine
import Firebase

@MainActor
final class AssignmentsViewModel: ObservableObject {
    @Published var assignments: [Assignment] = []
    @Published var availableCourses: [Course] = []

    // Load all assignments from Firestore
    func loadAssignments() {
        FirebaseManager.shared.fetchAssignments { [weak self] fetched in
            DispatchQueue.main.async {
                self?.assignments = fetched
            }
        }
    }

    // Load courses from parent view (e.g. CoursesViewModel)
    func updateCourses(_ newCourses: [Course]) {
        availableCourses = newCourses
    }

    // Add a new assignment and save it to Firestore + schedule reminders
    func addAssignment(title: String, course: Course, dueDate: Date, notes: String, priority: Priority) {
        let newAssignment = Assignment(
            title: title,
            courseId: course.id,
            dueDate: dueDate,
            notes: notes,
            completed: false,
            priority: priority
        )

        assignments.append(newAssignment)
        FirebaseManager.shared.saveAssignment(newAssignment)

        // Schedule notifications 7d / 3d / 1d before due date
        NotificationManager.shared.schedulePreDueReminders(for: newAssignment)
    }

    // Toggle completion and update Firestore
    func toggleComplete(_ assignment: Assignment) {
        if let index = assignments.firstIndex(where: { $0.id == assignment.id }) {
            assignments[index].completed.toggle()
            FirebaseManager.shared.saveAssignment(assignments[index])
        }
    }

    // Delete assignment from Firestore
    func delete(_ assignment: Assignment) {
        assignments.removeAll { $0.id == assignment.id }
        FirebaseManager.shared.deleteAssignment(assignment.id)
    }
}
