//
//  CoursesViewModel.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation
import Combine

@MainActor
final class CoursesViewModel: ObservableObject {
    @Published var courses: [Course] = []

    func loadCourses() {
        FirebaseManager.shared.fetchCourses { [weak self] fetched in
            DispatchQueue.main.async { self?.courses = fetched }
        }
    }

    func addCourse(code: String, name: String, professor: String, schedule: String, location: String, color: String) {
        let newCourse = Course(code: code, name: name, professor: professor, schedule: schedule, location: location, color: color)
        courses.append(newCourse)
        FirebaseManager.shared.saveCourse(newCourse)
    }

    func deleteCourse(_ course: Course) {
        courses.removeAll { $0.id == course.id }
        FirebaseManager.shared.deleteCourse(course.id)
    }
}
