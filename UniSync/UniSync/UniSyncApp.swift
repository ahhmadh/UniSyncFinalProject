//
//  UniSyncApp.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import SwiftUI
import Firebase

@main
struct UniSyncApp: App {
    init() {
        FirebaseApp.configure()
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
 
