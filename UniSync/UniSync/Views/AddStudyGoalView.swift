//
//  AddStudyGoalView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct AddStudyGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: StudyGoalsViewModel

    @State private var selectedCourse: Course?
    @State private var title: String = ""
    @State private var targetHours: Double = 10

    var body: some View {
        NavigationStack {
            Form {
                Section("Course") {
                    Picker("Select Course", selection: $selectedCourse) {
                        ForEach(viewModel.availableCourses, id: \.id) { course in
                            Text(course.name).tag(Optional(course))
                        }
                    }
                }

                Section("Goal") {
                    TextField("Goal title", text: $title)
                    HStack {
                        Text("Target Hours")
                        Spacer()
                        Text("\(targetHours, specifier: "%.1f")h")
                    }
                    Slider(value: $targetHours, in: 1...40, step: 0.5)
                }
            }
            .navigationTitle("New Study Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let course = selectedCourse, !title.trimmingCharacters(in: .whitespaces).isEmpty {
                            viewModel.addGoal(title: title, course: course, targetHours: targetHours)
                            dismiss()
                        }
                    }
                    .disabled(selectedCourse == nil || title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                // Preselect first course, if any
                if selectedCourse == nil { selectedCourse = viewModel.availableCourses.first }
            }
        }
    }
}
