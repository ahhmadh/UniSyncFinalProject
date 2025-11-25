//
//  RootView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI
import FirebaseAuth
import FirebaseCore

struct RootView: View {
    @State private var isAuthenticated = false
    @State private var isProfileComplete = false
    @State private var isLoading = true

    @StateObject private var coursesVM = CoursesViewModel()
    @StateObject private var assignmentsVM = AssignmentsViewModel()

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if !isAuthenticated {
                LoginView(onLoginSuccess: {
                    checkUserStatus()
                })
            } else if !isProfileComplete {
                OnboardingView { semester, image in
                    if let email = Auth.auth().currentUser?.email {
                        if let image = image {
                            FirebaseManager.shared.uploadProfileImage(image) { url in
                                FirebaseManager.shared.saveUserProfile(email: email, semester: semester, profileImageUrl: url) { _ in
                                    isProfileComplete = true
                                }
                            }
                        } else {
                            FirebaseManager.shared.saveUserProfile(email: email, semester: semester, profileImageUrl: nil) { _ in
                                isProfileComplete = true
                            }
                        }
                    }
                }
            } else {
                mainTabView
            }
        }
        .onAppear {
            setupFirebase()
        }
    }

    // MARK: - Setup Firebase
    private func setupFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        checkUserStatus()
    }

    // MARK: - Main TabView
    private var mainTabView: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house") }

            CoursesView(viewModel: coursesVM)
                .tabItem { Label("Courses", systemImage: "book.closed") }

            AssignmentsView(viewModel: assignmentsVM, coursesVM: coursesVM)
                .tabItem { Label("Tasks", systemImage: "doc.text") }

            StudyGoalsView(coursesVM: coursesVM)
                .tabItem { Label("Goals", systemImage: "target") }

            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .onAppear {
            coursesVM.loadCourses()
        }
    }

    // MARK: - Auth Check
    private func checkUserStatus() {
        if let user = Auth.auth().currentUser {
            print("✅ User logged in: \(user.email ?? "Unknown")")
            isAuthenticated = true
            FirebaseManager.shared.fetchUserProfile { exists, _ in
                isProfileComplete = exists
                isLoading = false
            }
        } else {
            print("⚠️ No user logged in.")
            isAuthenticated = false
            isLoading = false
        }
    }
}
