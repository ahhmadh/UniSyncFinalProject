//
//  AddAssignmentsView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct AddAssignmentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AssignmentsViewModel

    @State private var selectedCourse: Course?
    @State private var title = ""
    @State private var dueDate = Date()
    @State private var priority: Priority = .medium
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Course Selection
                Section(header: Text("Course")) {
                    Picker("Select Course", selection: $selectedCourse) {
                        ForEach(viewModel.availableCourses, id: \.id) { course in
                            Text(course.name).tag(Optional(course))
                        }
                    }
                }

                // MARK: - Assignment Details
                Section(header: Text("Assignment Details")) {
                    TextField("Assignment Title", text: $title)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)

                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)

                    TextField("Notes (optional)", text: $notes)
                }
            }
            .navigationTitle("New Assignment")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let selectedCourse else { return }

                        viewModel.addAssignment(
                            title: title,
                            course: selectedCourse,
                            dueDate: dueDate,
                            notes: notes,
                            priority: priority
                        )

                        dismiss()
                    }
                    .disabled(title.isEmpty || selectedCourse == nil)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
