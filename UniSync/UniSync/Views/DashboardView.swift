//
//  DashboardView.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import SwiftUI
import Combine

struct DashboardView: View {
    @StateObject private var vm = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        stat("Courses", "\(vm.courses.count)", .blue, "book.closed.fill")
                        stat("Pending", "\(vm.pendingAssignments.count)", .orange, "doc.text.fill")
                    }
                    HStack {
                        stat("Goals", "\(vm.goals.count)", .purple, "target")
                        stat("Studied", "\(Int(vm.totalHours))h", .green, "clock.fill")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming Tasks").font(.headline)
                        if vm.pendingAssignments.isEmpty {
                            Text("No upcoming assignments 🎉")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(vm.pendingAssignments.prefix(5)) { a in
                                HStack {
                                    Text(a.title).bold()
                                    Spacer()
                                    Text(a.dueDate, style: .date).foregroundStyle(.secondary)
                                }
                                .padding().background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding()
                .onAppear { vm.load() }
            }
            .navigationTitle("Dashboard")
        }
    }

    private func stat(_ title: String, _ value: String, _ color: Color, _ icon: String) -> some View {
        VStack {
            Image(systemName: icon).foregroundStyle(color)
            Text(value).font(.title.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
