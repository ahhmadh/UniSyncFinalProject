//
//  StudyGoalsView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct StudyGoalsView: View {
    @StateObject var viewModel = StudyGoalsViewModel()
    @ObservedObject var coursesVM: CoursesViewModel
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                if coursesVM.courses.isEmpty {
                    VStack(spacing: 10) {
                        Text("No courses found").font(.headline).foregroundColor(.gray)
                        Text("Please add a course first.").font(.subheadline).foregroundColor(.secondary)
                    }
                } else if viewModel.studyGoals.isEmpty {
                    VStack(spacing: 10) {
                        Text("No study goals yet").font(.headline).foregroundColor(.gray)
                        Button(action: { showingAddSheet = true }) {
                            Label("Add Study Goal", systemImage: "plus.circle.fill")
                        }
                        .tint(.blue)
                    }
                } else {
                    List {
                        ForEach(viewModel.studyGoals, id: \.id) { goal in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(goal.title).font(.headline)

                                if let course = viewModel.availableCourses.first(where: { $0.id == goal.courseId }) {
                                    Text(course.name)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                ProgressView(value: goal.completedHours, total: goal.targetHours)
                                    .tint(goal.completedHours >= goal.targetHours ? .green : .blue)

                                HStack {
                                    Text("\(goal.completedHours, specifier: "%.1f")h / \(goal.targetHours, specifier: "%.1f")h")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Button("Log +1h") {
                                        viewModel.logHours(for: goal, hours: 1)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.blue)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.delete(goal)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Study Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(coursesVM.courses.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddStudyGoalView(viewModel: viewModel)
                    .onAppear { viewModel.updateCourses(coursesVM.courses) }
            }
        }
    }
}
