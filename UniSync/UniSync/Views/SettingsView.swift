//
//  SettingsView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    @StateObject private var authVM = AuthViewModel()

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Appearance
                Section("Appearance") {
                    Picker("Theme", selection: $vm.settings.theme) {
                        ForEach(ThemeChoice.allCases) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                        }
                    }
                }

                // MARK: - Preferences
                Section("Preferences") {
                    Toggle("Enable Notifications", isOn: $vm.settings.notificationsEnabled)
                    TextField("Current Semester", text: $vm.settings.semester)
                }

                // MARK: - Save Settings
                Section {
                    Button("Save Settings") {
                        vm.save(vm.settings)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }

                // MARK: - Logout
                Section {
                    Button(role: .destructive) {
                        authVM.logout()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear { vm.load() }
        }
        // ✅ Redirect to LoginView when logged out
        .fullScreenCover(isPresented: .constant(!authVM.isLoggedIn)) {
            LoginView {
                authVM.isLoggedIn = true
            }
        }
    }
}
