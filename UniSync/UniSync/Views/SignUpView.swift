//
//  SignUpView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct SignUpView: View {
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.title.bold())

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

                // ✅ Fixed Sign Up Button
                Button("Sign Up") {
                    vm.signUp { success in
                        if success {
                            // Automatically dismiss and proceed (login successful)
                            dismiss()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(vm.email.isEmpty || vm.password.isEmpty)

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
