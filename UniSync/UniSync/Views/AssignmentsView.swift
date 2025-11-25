//
//  AssignmentsView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct AssignmentsView: View {
    @StateObject var viewModel = AssignmentsViewModel()
    @ObservedObject var coursesVM: CoursesViewModel
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                if coursesVM.courses.isEmpty {
                    VStack(spacing: 10) {
                        Text("No courses found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Please add a course first.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else if viewModel.assignments.isEmpty {
                    Text("No assignments yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Button(action: { showingAddSheet = true }) {
                        Label("Add Assignment", systemImage: "plus.circle.fill")
                            .tint(.blue)
                    }
                } else {
                    List {
                        ForEach(viewModel.assignments) { assignment in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(assignment.title).font(.headline)

                                    if let course = viewModel.availableCourses.first(where: { $0.id == assignment.courseId }) {
                                        Text(course.name).font(.subheadline).foregroundColor(.secondary)
                                    }

                                    Text("Due: \(formattedDate(from: assignment.dueDate))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Circle()
                                    .fill(priorityColor(assignment.priority))
                                    .frame(width: 10, height: 10)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.delete(assignment)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    viewModel.toggleComplete(assignment)
                                } label: {
                                    Label("Complete", systemImage: assignment.completed ? "checkmark.circle.fill" : "checkmark.circle")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Assignments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(coursesVM.courses.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddAssignmentView(viewModel: viewModel)
                    .onAppear {
                        viewModel.updateCourses(coursesVM.courses)
                    }
            }
        }
    }

    // MARK: - Helpers
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}
