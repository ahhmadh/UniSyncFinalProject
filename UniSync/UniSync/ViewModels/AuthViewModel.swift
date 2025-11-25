//
//  AuthViewModel.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//



import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoggedIn = false

    init() {
        isLoggedIn = AuthManager.shared.isLoggedIn
    }

    // ✅ Updated login with completion handler
    func login(completion: @escaping (Bool) -> Void) {
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                    self?.errorMessage = ""
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }

    // ✅ Updated signUp with completion handler
    func signUp(completion: @escaping (Bool) -> Void) {
        AuthManager.shared.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                    self?.errorMessage = ""
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }

    func logout() {
        AuthManager.shared.signOut()
        isLoggedIn = false
    }
}
