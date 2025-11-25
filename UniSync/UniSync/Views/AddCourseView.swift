//
//  AddCourseView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct AddCourseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CoursesViewModel

    @State private var code = ""
    @State private var name = ""
    @State private var professor = ""
    @State private var schedule = ""
    @State private var location = ""
    @State private var color = "#3B82F6"

    var body: some View {
        NavigationStack {
            Form {
                TextField("Course Code", text: $code)
                TextField("Course Name", text: $name)
                TextField("Professor", text: $professor)
                TextField("Schedule", text: $schedule)
                TextField("Location", text: $location)
                TextField("Color (Hex)", text: $color)
            }
            .navigationTitle("New Course")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !code.isEmpty && !name.isEmpty else { return }
                        viewModel.addCourse(code: code, name: name, professor: professor, schedule: schedule, location: location, color: color)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
