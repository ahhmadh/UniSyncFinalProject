//
//  FirebaseManager.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UIKit

final class FirebaseManager {
    static let shared = FirebaseManager()

    // MARK: - Firestore Instance
    private let db: Firestore

    private init() {
        // ✅ Ensure Firebase is configured before any Firestore calls
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        db = Firestore.firestore()
    }

    // MARK: - Helper to Get Current User
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - COURSES
    func saveCourse(_ course: Course) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot save course.")
            return
        }

        let data: [String: Any] = [
            "id": course.id,
            "code": course.code,
            "name": course.name,
            "professor": course.professor,
            "schedule": course.schedule,
            "location": course.location,
            "color": course.color
        ]

        db.collection("users").document(userId)
            .collection("courses").document(course.id)
            .setData(data) { error in
                if let error = error {
                    print("🔥 Error saving course:", error.localizedDescription)
                } else {
                    print("✅ Saved course for user \(userId)")
                }
            }
    }

    func fetchCourses(completion: @escaping ([Course]) -> Void) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot fetch courses.")
            completion([])
            return
        }

        db.collection("users").document(userId)
            .collection("courses").getDocuments { snapshot, error in
                if let error = error {
                    print("🔥 Error fetching courses:", error.localizedDescription)
                    completion([])
                    return
                }

                let courses = snapshot?.documents.compactMap { doc -> Course? in
                    let d = doc.data()
                    return Course(
                        id: d["id"] as? String ?? UUID().uuidString,
                        code: d["code"] as? String ?? "",
                        name: d["name"] as? String ?? "",
                        professor: d["professor"] as? String ?? "",
                        schedule: d["schedule"] as? String ?? "",
                        location: d["location"] as? String ?? "",
                        color: d["color"] as? String ?? "#000000"
                    )
                } ?? []

                completion(courses)
            }
    }

    func deleteCourse(_ courseId: String) {
        guard let userId = userId else { return }

        db.collection("users").document(userId)
            .collection("courses").document(courseId)
            .delete { error in
                if let error = error {
                    print("🔥 Error deleting course:", error.localizedDescription)
                }
            }
    }

    // MARK: - ASSIGNMENTS
    func saveAssignment(_ assignment: Assignment) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot save assignment.")
            return
        }

        let data: [String: Any] = [
            "id": assignment.id,
            "title": assignment.title,
            "courseId": assignment.courseId,
            "dueDate": Timestamp(date: assignment.dueDate),
            "notes": assignment.notes,
            "completed": assignment.completed,
            "priority": assignment.priority.rawValue
        ]

        db.collection("users").document(userId)
            .collection("assignments").document(assignment.id)
            .setData(data) { error in
                if let error = error {
                    print("🔥 Error saving assignment:", error.localizedDescription)
                } else {
                    print("✅ Saved assignment for user \(userId)")
                }
            }
    }

    func fetchAssignments(completion: @escaping ([Assignment]) -> Void) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot fetch assignments.")
            completion([])
            return
        }

        db.collection("users").document(userId)
            .collection("assignments").getDocuments { snapshot, error in
                if let error = error {
                    print("🔥 Error fetching assignments:", error.localizedDescription)
                    completion([])
                    return
                }

                let assignments = snapshot?.documents.compactMap { doc -> Assignment? in
                    let d = doc.data()
                    return Assignment(
                        id: d["id"] as? String ?? UUID().uuidString,
                        title: d["title"] as? String ?? "",
                        courseId: d["courseId"] as? String ?? "",
                        dueDate: (d["dueDate"] as? Timestamp)?.dateValue() ?? Date(),
                        notes: d["notes"] as? String ?? "",
                        completed: d["completed"] as? Bool ?? false,
                        priority: Priority(rawValue: d["priority"] as? String ?? "medium") ?? .medium
                    )
                } ?? []

                completion(assignments)
            }
    }

    func deleteAssignment(_ assignmentId: String) {
        guard let userId = userId else { return }

        db.collection("users").document(userId)
            .collection("assignments").document(assignmentId)
            .delete { error in
                if let error = error {
                    print("🔥 Error deleting assignment:", error.localizedDescription)
                }
            }
    }

    // MARK: - STUDY GOALS
    func saveGoal(_ goal: StudyGoal) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot save goal.")
            return
        }

        let data: [String: Any] = [
            "id": goal.id,
            "title": goal.title,
            "courseId": goal.courseId,
            "targetHours": goal.targetHours,
            "completedHours": goal.completedHours
        ]

        db.collection("users").document(userId)
            .collection("studyGoals").document(goal.id)
            .setData(data) { error in
                if let error = error {
                    print("🔥 Error saving study goal:", error.localizedDescription)
                } else {
                    print("✅ Saved study goal for user \(userId)")
                }
            }
    }

    func fetchGoals(completion: @escaping ([StudyGoal]) -> Void) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot fetch goals.")
            completion([])
            return
        }

        db.collection("users").document(userId)
            .collection("studyGoals").getDocuments { snapshot, error in
                if let error = error {
                    print("🔥 Error fetching study goals:", error.localizedDescription)
                    completion([])
                    return
                }

                let goals = snapshot?.documents.compactMap { doc -> StudyGoal? in
                    let d = doc.data()
                    return StudyGoal(
                        id: d["id"] as? String ?? UUID().uuidString,
                        title: d["title"] as? String ?? "",
                        courseId: d["courseId"] as? String ?? "",
                        targetHours: d["targetHours"] as? Double ?? 0.0,
                        completedHours: d["completedHours"] as? Double ?? 0.0
                    )
                } ?? []

                completion(goals)
            }
    }

    func deleteGoal(_ goalId: String) {
        guard let userId = userId else { return }

        db.collection("users").document(userId)
            .collection("studyGoals").document(goalId)
            .delete { error in
                if let error = error {
                    print("🔥 Error deleting goal:", error.localizedDescription)
                }
            }
    }

    // MARK: - SETTINGS
    func saveSettings(_ settings: UserSettings, completion: ((Error?) -> Void)? = nil) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot save settings.")
            return
        }

        let data: [String: Any] = [
            "theme": settings.theme.rawValue,
            "notificationsEnabled": settings.notificationsEnabled,
            "semester": settings.semester
        ]

        db.collection("users").document(userId)
            .collection("settings").document("app_settings")
            .setData(data) { error in
                if let error = error {
                    print("🔥 Error saving settings:", error.localizedDescription)
                }
                completion?(error)
            }
    }

    func fetchSettings(completion: @escaping (UserSettings) -> Void) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot fetch settings.")
            completion(UserSettings())
            return
        }

        db.collection("users").document(userId)
            .collection("settings").document("app_settings")
            .getDocument { snap, error in
                if let error = error {
                    print("🔥 Error fetching settings:", error.localizedDescription)
                    completion(UserSettings())
                    return
                }

                let d = snap?.data() ?? [:]
                let theme = ThemeChoice(rawValue: (d["theme"] as? String ?? "system")) ?? .system
                let notificationsEnabled = d["notificationsEnabled"] as? Bool ?? true
                let semester = d["semester"] as? String ?? "Fall 2025"
                completion(UserSettings(theme: theme, notificationsEnabled: notificationsEnabled, semester: semester))
            }
    }

    // MARK: - PROFILE (Onboarding)
    func uploadProfileImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot upload image.")
            completion(nil)
            return
        }

        let ref = Storage.storage().reference().child("profileImages/\(userId).jpg")
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("⚠️ Failed to compress image.")
            completion(nil)
            return
        }

        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("🔥 Upload error:", error.localizedDescription)
                completion(nil)
                return
            }

            ref.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }

    func saveUserProfile(email: String, semester: String, profileImageUrl: String?, completion: ((Error?) -> Void)? = nil) {
        guard let userId = userId else {
            print("⚠️ No user logged in — cannot save user profile.")
            return
        }

        var data: [String: Any] = [
            "email": email,
            "semester": semester,
            "createdAt": Timestamp(date: Date())
        ]

        if let profileImageUrl = profileImageUrl {
            data["profileImageUrl"] = profileImageUrl
        }

        db.collection("users").document(userId)
            .collection("profile").document("info")
            .setData(data, completion: completion)
    }

    func fetchUserProfile(completion: @escaping (_ exists: Bool, _ semester: String?) -> Void) {
        guard let userId = userId else {
            completion(false, nil)
            return
        }

        db.collection("users").document(userId)
            .collection("profile").document("info")
            .getDocument { snapshot, error in
                if let error = error {
                    print("🔥 Error fetching user profile:", error.localizedDescription)
                    completion(false, nil)
                    return
                }

                if let data = snapshot?.data(),
                   let semester = data["semester"] as? String {
                    completion(true, semester)
                } else {
                    completion(false, nil)
                }
            }
    }
}
