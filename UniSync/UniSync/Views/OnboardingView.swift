//
//  OnboardingView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct OnboardingView: View {
    @State private var semester = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showPhotoPicker = false
    @State private var showCamera = false

    var onComplete: (String, UIImage?) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Set Up Your Profile")
                .font(.largeTitle.bold())

            // MARK: Profile Image
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 90))
                        .foregroundColor(.gray)
                }

                HStack {
                    Button("📸 Camera") { showCamera = true }
                        .buttonStyle(.borderedProminent)
                    Button("🖼️ Gallery") { showPhotoPicker = true }
                        .buttonStyle(.bordered)
                }
            }

            // MARK: Semester
            VStack(alignment: .leading) {
                Text("Current Semester").bold()
                TextField("e.g., Fall 2025", text: $semester)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()

            Button {
                onComplete(semester, selectedImage)
            } label: {
                Text("Complete Setup")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal)
        }
        .padding()
        .sheet(isPresented: $showPhotoPicker) {
            ImagePicker(image: $selectedImage)
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(image: $selectedImage)
        }
    }
}
