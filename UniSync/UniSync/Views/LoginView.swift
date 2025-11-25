//
//  LoginView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @StateObject private var vm = AuthViewModel()
    @State private var showingSignUp = false

    // ✅ Callback for RootView
    var onLoginSuccess: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("UniSync")
                .font(.largeTitle.bold())

            // MARK: - Email Login
            TextField("Email", text: $vm.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if !vm.errorMessage.isEmpty {
                Text(vm.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // MARK: - Login Button
            Button("Sign In") {
                vm.login { success in
                    if success {
                        onLoginSuccess()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .disabled(vm.email.isEmpty || vm.password.isEmpty)

            // MARK: - Create Account
            Button("Create Account") {
                showingSignUp = true
            }
            .tint(.blue)

            Divider().padding(.vertical)

            // MARK: - Google Sign-In
            GoogleSignInButton {
                guard let rootVC = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                    .first else { return }

                AuthManager.shared.signInWithGoogle(presenting: rootVC) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            vm.isLoggedIn = true
                            onLoginSuccess()
                        case .failure(let error):
                            vm.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingSignUp) {
            SignUpView(vm: vm)
        }
    }
}
