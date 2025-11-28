//
//  RootView.swift
//  UniSync
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

struct RootView: View {
    @State private var isAuthenticated = false
    @State private var isProfileComplete = false
    @State private var isLoading = true

    @State private var profileImageUrl: String? = nil  

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

                            print("📸 Complete tapped — image selected = YES")

                            FirebaseManager.shared.uploadProfileImage(image) { url in
                                print("🔗 uploadProfileImage returned URL =", url ?? "nil")

                                FirebaseManager.shared.saveUserProfile(email: email, semester: semester, profileImageUrl: url) { error in

                                    if let error = error {
                                        print("❌ Error saving profile:", error.localizedDescription)
                                    } else {
                                        print("✅ Profile saved successfully with URL:", url ?? "nil")
                                    }

                                    self.profileImageUrl = url
                                    self.isProfileComplete = true
                                }
                            }

                        } else {

                            print("📸 Complete tapped — NO image selected")

                            FirebaseManager.shared.saveUserProfile(email: email, semester: semester, profileImageUrl: nil) { error in
                                if let error = error {
                                    print("❌ Error saving profile:", error.localizedDescription)
                                } else {
                                    print("✅ Profile saved successfully (no image)")
                                }

                                self.profileImageUrl = nil
                                self.isProfileComplete = true
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

        // Force logout for testing
//        try? Auth.auth().signOut()
//        GIDSignIn.sharedInstance.signOut()

        checkUserStatus()
    }

    // MARK: - Main TabView
    private var mainTabView: some View {
        TabView {
            DashboardView(profileImageUrl: profileImageUrl)  
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
            print("✅ Logged in as: \(user.email ?? "Unknown")")
            isAuthenticated = true

            FirebaseManager.shared.fetchUserProfile { exists, data in
                isProfileComplete = exists
                if let email = user.email {
                    FirebaseManager.shared.getProfileImageUrl { url in
                        self.profileImageUrl = url
                    }
                }

                isLoading = false
            }
        } else {
            print("⚠️ No logged-in user. Showing LoginView.")
            isAuthenticated = false
            isLoading = false
        }
    }
}
