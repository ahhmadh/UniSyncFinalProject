//
//  UserSetting.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation

enum ThemeChoice: String, Codable, CaseIterable, Identifiable {
    case light, dark, system
    var id: String { rawValue }
}

struct UserSettings: Codable, Equatable {
    var theme: ThemeChoice = .system
    var notificationsEnabled: Bool = true
    var semester: String = "Fall 2025"
}
