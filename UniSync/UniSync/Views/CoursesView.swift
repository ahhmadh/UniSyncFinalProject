//
//  CoursesView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI

struct CoursesView: View {
    @StateObject var viewModel = CoursesViewModel()
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.courses) { course in
                    VStack(alignment: .leading) {
                        Text(course.name).font(.headline)
                        Text(course.code).font(.subheadline).foregroundColor(.secondary)
                        Text(course.professor).font(.caption)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddCourseView(viewModel: viewModel)
            }
        }
        .onAppear { viewModel.loadCourses() }
    }

    func delete(at offsets: IndexSet) {
        offsets.map { viewModel.courses[$0] }.forEach(viewModel.deleteCourse)
    }
}
