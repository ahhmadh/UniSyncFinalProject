//
//  AuthManager.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UIKit

final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    // MARK: - Firebase Email Authentication
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Sign-out error: \(error.localizedDescription)")
        }
    }

    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    // MARK: - Google Sign-In
    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Missing Firebase client ID.")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing ID token"])))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let authUser = authResult?.user {
                    completion(.success(authUser))
                }
            }
        }
    }
}
