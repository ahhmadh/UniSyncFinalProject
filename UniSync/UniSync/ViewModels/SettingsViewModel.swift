//
//  SettingsViewModel.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation
import Combine  // ✅ Required for ObservableObject & @Published

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var settings = UserSettings()

    func load() {
        FirebaseManager.shared.fetchSettings { [weak self] fetchedSettings in
            DispatchQueue.main.async {
                self?.settings = fetchedSettings
            }
        }
    }

    func save(_ s: UserSettings) {
        settings = s
        FirebaseManager.shared.saveSettings(s) { error in
            if let error = error {
                print("🔥 Error saving settings:", error.localizedDescription)
            } else {
                print("✅ Settings saved successfully")
            }
        }
    }
}
